#!/usr/bin/env bash
#
# local-nvchecker-coverage-expand.sh — Enroll every trackable image in the
# nvchecker registry so the auto-bump pipeline can see it.
#
# For each image directory under images/ that isn't already listed in
# nvchecker-images.json, this parses the image's default.nix and:
#   - If it fetches from GitHub (fetchFromGitHub or a github.com URL),
#     adds a `[<name>]` block to nvchecker.toml with source=github,
#     github=<owner>/<repo>, use_latest_release=true, and a v-prefix hint.
#   - Adds { <name>: [<image>] } to nvchecker-images.json.
#   - Seeds { <name>: <current-version> } in old_versions.json so the FIRST
#     nvcmp doesn't show a bogus 0→new diff.
#
# Skips images whose default.nix uses drv = pkgs.<attr> (nixpkgs-managed;
# those are the domain of scripts/local-auto-update.sh / auto-update.yml
# via `nix flake update` + `nix-update`), as well as pullImage and
# non-GitHub fetchurl variants that don't have a clean owner/repo pair.
# A summary of the skipped set is printed at the end.
#
# Idempotent: re-running doesn't add duplicates.
#
# Usage:
#   scripts/local-nvchecker-coverage-expand.sh              # scan + add
#   scripts/local-nvchecker-coverage-expand.sh --dry-run    # print what
#                                                            # would be added

set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

python3 - "$DRY" <<'PY'
import json, os, re, sys

dry = sys.argv[1] == "1"

with open('nvchecker-images.json') as f:
    idx = json.load(f)
tracked = set()
for entry, imgs in idx.items():
    for i in imgs: tracked.add(i)

old_ver = {}
if os.path.exists('old_versions.json'):
    with open('old_versions.json') as f:
        old_ver = json.load(f)

with open('nvchecker.toml') as f:
    nv_toml = f.read()
existing_entries = set(re.findall(r'^\[([^\]\s]+)\]', nv_toml, re.MULTILINE))

# Regexes for parsing default.nix
RE_FROM_GH = re.compile(
    r'fetchFromGitHub\s*\{[^}]*?owner\s*=\s*"([^"]+)"[^}]*?repo\s*=\s*"([^"]+)"',
    re.DOTALL)
# Only match github URLs inside a fetch{url,zip,Tarball,git} block — bare URLs in
# comments/labels (e.g. org.opencontainers.image.source labels pointing at our
# own repo) would otherwise be treated as the upstream source.
RE_FETCH_GH_URL = re.compile(
    r'fetch(?:url|zip|Tarball|Git|tree)\s*\{[^}]*?url\s*=\s*"[^"]*?github\.com/([^/"\s]+)/([^/"\s]+?)(?:/|"|\.git)',
    re.DOTALL)
# GitLab equivalents. owner may be a group path (group/subgroup); repo is the
# final path segment. nvchecker's gitlab source polls tags for the newest.
RE_FROM_GL = re.compile(
    r'fetchFromGitLab\s*\{[^}]*?owner\s*=\s*"([^"]+)"[^}]*?repo\s*=\s*"([^"]+)"',
    re.DOTALL)
RE_FETCH_GL_URL = re.compile(
    r'fetch(?:url|zip|Tarball|Git|tree)\s*\{[^}]*?url\s*=\s*"[^"]*?gitlab\.com/([^"\s]+?)/([^/"\s]+?)(?:/|"|\.git)',
    re.DOTALL)
RE_VERSION = re.compile(r'^\s*version\s*=\s*"([^"]+)"', re.MULTILINE)
RE_DRV_PKGS = re.compile(r'drv\s*=\s*pkgs\.[a-zA-Z0-9_.-]+')
# `drv = X;` where X is a let-bound name whose right-hand side comes from
# `pkgs.something`. Effectively also nixpkgs-tracked, one indirection deeper.
RE_DRV_BINDING = re.compile(
    r'drv\s*=\s*([a-zA-Z][a-zA-Z0-9_-]*)(?:\.[a-zA-Z0-9_-]+)?\s*;')
RE_LET_BINDING = lambda name: re.compile(
    rf'^\s*{re.escape(name)}\s*=\s*(?:pkgs\.[a-zA-Z0-9_.-]+|[a-zA-Z][a-zA-Z0-9_-]*\.[a-zA-Z0-9_.-]+)',
    re.MULTILINE)
# For "argo-workflows.argo-cli" style: track "argo-workflows" the let-name
# resolves through — if that name itself is `= pkgs.<attr>` in the file,
# it's nixpkgs-indirect.
RE_LET_PKGS_BINDING = lambda name: re.compile(
    rf'^\s*{re.escape(name)}\s*=\s*pkgs\.[a-zA-Z0-9_.-]+',
    re.MULTILINE)
# Upstream-reference stubs: docker.io/OWNER/REPO or docker.io/REPO (library images).
# The tag itself is the "version" we want to track — nvchecker's container source
# polls the registry for the newest matching tag.
RE_UPSTREAM_LABEL = re.compile(
    r'"io\.nix-containers\.upstream-image"\s*=\s*"([^"]+)"')
RE_TAG_LINE = re.compile(r'^\s*tag\s*=\s*"([^"]+)"', re.MULTILINE)

# Owners that are false positives (our own repo, generic mirrors, etc.).
BAD_OWNERS = {"nix-containers"}

# registry.k8s.io hand-mappings from image path → GitHub owner/repo. These
# fill the gap while nvchecker's container source can't authenticate against
# registry.k8s.io.
K8SIO_MAP = {
    "autoscaling/vpa-admission-controller":     "kubernetes/autoscaler",
    "autoscaling/vpa-recommender":              "kubernetes/autoscaler",
    "autoscaling/vpa-updater":                  "kubernetes/autoscaler",
    "csi-secrets-store/driver":                 "kubernetes-sigs/secrets-store-csi-driver",
    "descheduler/descheduler":                  "kubernetes-sigs/descheduler",
    "ingress-nginx/controller":                 "kubernetes/ingress-nginx",
    "ingress-nginx/opentelemetry":              "kubernetes/ingress-nginx",
    "networking/ip-masq-agent":                 "kubernetes-sigs/ip-masq-agent",
    "provider-aws/cloud-controller-manager":    "kubernetes/cloud-provider-aws",
    "sig-storage/local-volume-node-cleanup":    "kubernetes-sigs/sig-storage-local-static-provisioner",
    "sig-storage/local-volume-provisioner":     "kubernetes-sigs/sig-storage-local-static-provisioner",
    "sig-storage/nfs-subdir-external-provisioner": "kubernetes-sigs/nfs-subdir-external-provisioner",
    "sig-storage/objectstorage-controller":     "kubernetes-sigs/container-object-storage-interface-controller",
    "sig-storage/objectstorage-sidecar":        "kubernetes-sigs/container-object-storage-interface-provisioner-sidecar",
}

def image_source(default_nix_path):
    with open(default_nix_path) as f:
        s = f.read()
    m = RE_FROM_GH.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "github", "owner": m.group(1), "repo": m.group(2), "src": s}
    m = RE_FETCH_GH_URL.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "github", "owner": m.group(1), "repo": m.group(2).rstrip('.'), "src": s}
    m = RE_FROM_GL.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "gitlab", "owner": m.group(1), "repo": m.group(2), "src": s}
    m = RE_FETCH_GL_URL.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "gitlab", "owner": m.group(1), "repo": m.group(2).rstrip('.'), "src": s}
    if RE_DRV_PKGS.search(s):
        return {"kind": "nixpkgs", "src": s}
    # Indirect nixpkgs: `drv = X;` where X is a let-bound `pkgs.<attr>` (or
    # a sub-attribute like `argo-workflows.argo-cli` whose root binds to
    # pkgs). Walk one hop of the resolution chain.
    m_drv = RE_DRV_BINDING.search(s)
    if m_drv:
        name = m_drv.group(1)
        # Direct: <name> = pkgs.<attr>
        if RE_LET_PKGS_BINDING(name).search(s):
            return {"kind": "nixpkgs", "src": s}
        # Two-hop: <name> = <name2>.<...>  and <name2> = pkgs.<attr>
        m_alias = re.search(
            rf'^\s*{re.escape(name)}\s*=\s*([a-zA-Z][a-zA-Z0-9_-]*)\.',
            s, re.MULTILINE)
        if m_alias and RE_LET_PKGS_BINDING(m_alias.group(1)).search(s):
            return {"kind": "nixpkgs", "src": s}
    # Composite images assembled from buildEnv/copyToRoot without a `drv =`.
    # Heuristic: if the image directory name (with any -fips suffix stripped)
    # matches a `pkgs.<attr>` reference in the file, treat as nixpkgs-indirect —
    # the image tracks whatever nixpkgs version of that attribute.
    img_name = os.path.basename(os.path.dirname(default_nix_path))
    stem = re.sub(r'-fips$', '', img_name)
    if stem and re.search(rf'pkgs\.{re.escape(stem)}\b', s):
        return {"kind": "nixpkgs", "src": s}
    m = RE_UPSTREAM_LABEL.search(s)
    if m:
        # Value is "REGISTRY/OWNER/REPO:TAG" or "REGISTRY/REPO:TAG" (library image).
        # nvchecker's container source supports Bearer-token auth only. Verified
        # (2026-07) that these registries answer the Bearer token dance and return
        # tags: docker.io, quay.io, ghcr.io, gcr.io, public.ecr.aws,
        # registry.gitlab.com, nvcr.io, docker.elastic.co, cr.l5d.io,
        # us-docker.pkg.dev, icr.io. registry.k8s.io and mcr.microsoft.com use a
        # non-Bearer scheme nvchecker can't poll — those fall back to K8SIO_MAP
        # (github) or stay unknown.
        POLLABLE = {"docker.io", "quay.io", "ghcr.io", "gcr.io", "public.ecr.aws",
                    "registry.gitlab.com", "nvcr.io", "docker.elastic.co",
                    "cr.l5d.io", "us-docker.pkg.dev", "icr.io"}
        upstream = m.group(1)
        registry, _, rest = upstream.partition("/")
        if not rest:
            return {"kind": "unknown", "src": s}
        container, _, _ = rest.partition(":")
        if registry in POLLABLE:
            # DockerHub's registry API rejects single-name paths ("nginx" → 401);
            # library images must be queried as "library/<name>".
            if registry == "docker.io" and "/" not in container:
                container = f"library/{container}"
            return {"kind": "container", "container": container, "registry": registry, "src": s}
        # registry.k8s.io images are Kubernetes SIG projects — hand-mapped to
        # their github source for github-source polling. Path stripped down to
        # the sub-project (e.g. "descheduler/descheduler" → "descheduler").
        if registry == "registry.k8s.io":
            gh = K8SIO_MAP.get(container)
            if gh:
                owner, repo = gh.split("/", 1)
                return {"kind": "github", "owner": owner, "repo": repo, "src": s}
        return {"kind": "unknown", "src": s}
    # nixpkgs-indirect: image assembled from nixpkgs packages (buildEnv /
    # copyToRoot / contents / paths = [ pkgs.X ]) or pinned to a
    # `pkgs.<attr>.version`. These track whatever nixpkgs ships and update via
    # `nix flake update` — no nvchecker entry needed. Guarded against
    # pullImage / fetch-based images whose version comes from an external
    # source rather than nixpkgs.
    if not re.search(r'pullImage|fetchurl|fetchzip|fetchTarball|fetchgit', s):
        if (re.search(r'(?:copyToRoot|contents|paths)\s*=\s*\[?[^;]*?pkgs\.[a-zA-Z]', s, re.DOTALL)
                or re.search(r'pkgs\.[a-zA-Z][\w.-]*\.version', s)):
            return {"kind": "nixpkgs", "src": s}
    return {"kind": "unknown", "src": s}

added_toml = []
added_mapping = {}
skipped = {"pkgs.attr": [], "unknown": [], "already-mapped-differently": []}
counts = {"github": 0, "container": 0, "gitlab": 0}

for img in sorted(os.listdir('images')):
    d = f'images/{img}'
    if not os.path.isdir(d): continue
    f = f'{d}/default.nix'
    if not os.path.exists(f): continue
    if img in tracked: continue

    info = image_source(f)
    if info["kind"] == "nixpkgs":
        skipped["pkgs.attr"].append(img)
        continue
    if info["kind"] == "unknown":
        skipped["unknown"].append(img)
        continue

    key = img
    if key in existing_entries:
        skipped["already-mapped-differently"].append(img)
        continue

    # TOML bare table keys allow only [A-Za-z0-9_-]. Names with `+`, `.`,
    # or other punctuation (e.g. `mosquitto-libs++`) need quoting.
    key_toml = key if re.fullmatch(r'[A-Za-z0-9_-]+', key) else f'"{key}"'

    if info["kind"] == "github":
        owner, repo = info["owner"], info["repo"].removesuffix(".git")
        m = RE_VERSION.search(info["src"])
        ver = m.group(1) if m else ""
        added_toml.append(
            f'[{key_toml}]\n'
            f'source = "github"\n'
            f'github = "{owner}/{repo}"\n'
            f'use_latest_release = true\n'
            f'prefix = "v"\n'
        )
        counts["github"] += 1
    elif info["kind"] == "gitlab":
        owner, repo = info["owner"], info["repo"].removesuffix(".git")
        m = RE_VERSION.search(info["src"])
        ver = m.group(1) if m else ""
        added_toml.append(
            f'[{key}]\n'
            f'source = "gitlab"\n'
            f'gitlab = "{owner}/{repo}"\n'
            f'use_max_tag = true\n'
            f'include_regex = "v?[0-9]+\\\\.[0-9]+(\\\\.[0-9]+)?"\n'
            f'prefix = "v"\n'
        )
        counts["gitlab"] += 1
    elif info["kind"] == "container":
        # Track the upstream tag. `include_regex` gates against date-based /
        # channel tags ("latest", "nightly", "20250107") — accept only tags
        # that look like a SemVer with an optional `v` prefix.
        m = RE_TAG_LINE.search(info["src"])
        ver = m.group(1) if m else ""
        stanza = (
            f'[{key_toml}]\n'
            f'source = "container"\n'
            f'container = "{info["container"]}"\n'
        )
        # docker.io is nvchecker's default registry — only emit `registry =`
        # for the others so we don't clutter the diff.
        if info["registry"] != "docker.io":
            stanza += f'registry = "{info["registry"]}"\n'
        stanza += (
            f'include_regex = "v?[0-9]+\\\\.[0-9]+(\\\\.[0-9]+)?"\n'
            f'prefix = "v"\n'
        )
        added_toml.append(stanza)
        counts["container"] += 1

    added_mapping[key] = [img]
    if ver and key not in old_ver:
        old_ver[key] = ver

# -fips variants inherit their non-fips sibling's version: they build the same
# upstream with FIPS crypto swapped in, so the sibling's tracking covers them.
# Attach the fips image to the sibling's nvchecker entry (it rebuilds when the
# sibling bumps); if the sibling is nixpkgs-tracked, `nix flake update` covers
# both and no entry is needed. The sibling name sorts before its "-fips"
# variant, so it has already been classified in the loop above.
img_to_entry = {}
for _k, _imgs in idx.items():
    for _i in _imgs: img_to_entry[_i] = _k
for _k, _imgs in added_mapping.items():
    for _i in _imgs: img_to_entry[_i] = _k
_nixpkgs_sibs = set(skipped["pkgs.attr"])
fips_inherited = 0
_still_unknown = []
for img in skipped["unknown"]:
    sib = img[:-5] if img.endswith("-fips") else (
        img.replace("-fips-", "-", 1) if "-fips-" in img else None)
    if sib and os.path.isdir(f'images/{sib}'):
        if sib in img_to_entry:
            entry = img_to_entry[sib]
            target = added_mapping.get(entry)
            if target is None: target = idx.get(entry)
            if target is not None and img not in target:
                target.append(img)
            fips_inherited += 1
            continue
        if sib in _nixpkgs_sibs:
            fips_inherited += 1  # covered via nixpkgs `nix flake update`
            continue
    _still_unknown.append(img)
skipped["unknown"] = _still_unknown
mapping_changed = fips_inherited > 0

print(f'== fips-inherited: {fips_inherited} -fips variants piggyback on their non-fips sibling')
print(f'== to add: {len(added_toml)} entries (github={counts["github"]}, gitlab={counts["gitlab"]}, container={counts["container"]})')
print(f'== skipped: pkgs.attr={len(skipped["pkgs.attr"])}  unknown={len(skipped["unknown"])}  already-mapped-differently={len(skipped["already-mapped-differently"])}')

if dry:
    print()
    for e in added_toml[:5]:
        print("  ---")
        print("  " + "\n  ".join(e.strip().splitlines()))
    if len(added_toml) > 5:
        print(f'  ...({len(added_toml)-5} more)')
    sys.exit(0)

# Persist.
if added_toml or mapping_changed:
    if added_toml:
        with open('nvchecker.toml', 'a') as f:
            f.write('\n# --- auto-added by local-nvchecker-coverage-expand.sh ---\n')
            for e in added_toml:
                f.write('\n' + e)

    # nvchecker-images.json: preserve original key ordering; append new keys.
    # (Also captures -fips images attached to an existing sibling entry.)
    for k, v in added_mapping.items():
        idx[k] = v
    with open('nvchecker-images.json', 'w') as f:
        json.dump(idx, f, indent=1)
        f.write('\n')

    # old_versions.json: same
    with open('old_versions.json', 'w') as f:
        json.dump(old_ver, f, indent=2)
        f.write('\n')

    print(f'wrote {len(added_toml)} entries + {fips_inherited} fips-inherited mappings '
          f'to nvchecker.toml + nvchecker-images.json + old_versions.json')
else:
    print('nothing to add')
PY
