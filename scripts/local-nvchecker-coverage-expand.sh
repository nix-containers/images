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
RE_VERSION = re.compile(r'^\s*version\s*=\s*"([^"]+)"', re.MULTILINE)
RE_DRV_PKGS = re.compile(r'drv\s*=\s*pkgs\.[a-zA-Z0-9_.-]+')

# Owners that are false positives (our own repo, generic mirrors, etc.).
BAD_OWNERS = {"nix-containers"}

def image_source(default_nix_path):
    with open(default_nix_path) as f:
        s = f.read()
    m = RE_FROM_GH.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "github", "owner": m.group(1), "repo": m.group(2), "src": s}
    m = RE_FETCH_GH_URL.search(s)
    if m and m.group(1) not in BAD_OWNERS:
        return {"kind": "github", "owner": m.group(1), "repo": m.group(2).rstrip('.'), "src": s}
    if RE_DRV_PKGS.search(s):
        return {"kind": "nixpkgs", "src": s}
    return {"kind": "unknown", "src": s}

added_toml = []
added_mapping = {}
skipped = {"pkgs.attr": [], "unknown": [], "already-mapped-differently": []}

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

    # GitHub-sourced. Use the image name as the nvchecker entry key so it's
    # 1:1 mappable back to the image dir; if the key clashes with an existing
    # entry, sidecar-mark and skip (operator's judgment call).
    key = img
    if key in existing_entries:
        skipped["already-mapped-differently"].append(img)
        continue

    owner, repo = info["owner"], info["repo"].removesuffix(".git")
    m = RE_VERSION.search(info["src"])
    ver = m.group(1) if m else ""

    added_toml.append(
        f'[{key}]\n'
        f'source = "github"\n'
        f'github = "{owner}/{repo}"\n'
        f'use_latest_release = true\n'
        f'prefix = "v"\n'
    )
    added_mapping[key] = [img]
    if ver and key not in old_ver:
        old_ver[key] = ver

print(f'== to add: {len(added_toml)} entries')
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
if added_toml:
    with open('nvchecker.toml', 'a') as f:
        f.write('\n# --- auto-added by local-nvchecker-coverage-expand.sh ---\n')
        for e in added_toml:
            f.write('\n' + e)

    # nvchecker-images.json: preserve original key ordering; append new keys.
    for k, v in added_mapping.items():
        idx[k] = v
    with open('nvchecker-images.json', 'w') as f:
        json.dump(idx, f, indent=1)
        f.write('\n')

    # old_versions.json: same
    with open('old_versions.json', 'w') as f:
        json.dump(old_ver, f, indent=2)
        f.write('\n')

    print(f'wrote {len(added_toml)} entries to nvchecker.toml + nvchecker-images.json + old_versions.json')
else:
    print('nothing to add')
PY
