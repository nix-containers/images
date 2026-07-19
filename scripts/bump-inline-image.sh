#!/usr/bin/env bash
# Bump an inline-fetch image (images/<name>/default.nix) to a new upstream
# version and repair every content hash it pins.
#
#   scripts/bump-inline-image.sh <image> <new-version>
#
# Strategy (fetcher-agnostic): rewrite `version = "..."`, then iteratively set
# each failing hash to a fake value, build, and read the real hash back out of
# Nix's "got:" mismatch error. This repairs src hashes AND buildGoModule
# vendorHash / cargoHash without per-fetcher special-casing. Builds for
# x86_64-linux. Exits non-zero (and reverts) if it can't converge.
#
# nix2container.pullImage: images that re-wrap an upstream registry image
# (imageName + imageDigest) can't be repaired by "just fake the hash and let
# Nix tell you" — the imageDigest is a manifest sha256 that Nix doesn't
# derive, it reads from the registry response. For those files this script:
#   1. Parses the file for `imageName` + a tag-pattern hint. The hint is
#      either an explicit `# bumper:tag = "<pattern>"` line, or the
#      `docker://<image>:<pattern>` in the update-doc comment. `<ver>` in
#      the pattern is substituted with the new version.
#   2. Runs `skopeo inspect docker://<image>:<tag>` to resolve the new
#      manifest digest, and rewrites `imageDigest = "..."` in the file.
#   3. Falls through to the normal hash-repair loop for the outer sha256
#      (the pullImage's file-set nar-hash, which nix DOES compute).
set -uo pipefail

IMG="${1:?usage: bump-inline-image.sh <image> <new-version>}"
NEW="${2:?usage: bump-inline-image.sh <image> <new-version>}"
F="images/${IMG}/default.nix"
SYS="x86_64-linux"
FAKE="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

[ -f "$F" ] || { echo "$IMG: no $F"; exit 2; }
ORIG=$(cat "$F")
revert() { printf '%s' "$ORIG" > "$F"; }

# Optional secondary nix store (e.g. a warm cache on another drive). When
# IMAGE_NIX_STORE is set, builds run against it and the converged build is
# pinned with a per-image gc root under IMAGE_NIX_ROOTS — so the cache is
# reused and, once a later bump moves the root, the old version becomes
# collectable by `nix store gc --store <store>`. Unset (default, incl. CI) →
# normal /nix store with --no-link, behaviour unchanged.
STORE_ARG=()
LINK_ARG=(--no-link)
if [ -n "${IMAGE_NIX_STORE:-}" ]; then
  STORE_ARG=(--store "${IMAGE_NIX_STORE}")
  ROOTS_DIR="${IMAGE_NIX_ROOTS:-/mnt/models/nixbuild-roots}"
  mkdir -p "$ROOTS_DIR"
  LINK_ARG=(--out-link "${ROOTS_DIR}/${IMG}")
fi

OLD=$(grep -oE '^[[:space:]]*version = "[^"]+"' "$F" | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
[ -z "$OLD" ] && { echo "$IMG: no version line"; exit 2; }

# Normalize the incoming version to match the local convention. Upstream
# nvchecker returns tags verbatim ("v1.2.3"); if the local file's version
# has no `v` prefix (and typically uses `rev = "v${version}"` to reconstruct
# the tag), stripping matches the local convention and avoids double-v regressions.
if [[ "$OLD" != v* && "$NEW" == v* ]]; then
  NEW="${NEW#v}"
fi

[ "$OLD" = "$NEW" ] && { echo "$IMG: already $NEW"; exit 0; }

# 1. bump the version
sed -i -E "0,/version = \"$OLD\"/s//version = \"$NEW\"/" "$F"

# 1b. pullImage path: refresh imageDigest via skopeo before the hash loop.
if grep -q 'pullImage' "$F"; then
  IMAGE_NAME=$(grep -oE 'imageName[[:space:]]*=[[:space:]]*"[^"]+"' "$F" \
    | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
  # Prefer an explicit `# bumper:tag = "<pattern>"` metadata line; fall
  # back to the "docker://<image>:<pattern>" pattern in the update comment.
  TAG_PATTERN=$(grep -oE '#[[:space:]]*bumper:tag[[:space:]]*=[[:space:]]*"[^"]+"' "$F" \
    | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -z "$TAG_PATTERN" ]; then
    # Look for any "<something>:<pattern>" where <pattern> contains `<ver>`.
    # This handles both `docker://…:<pattern>` (non-fips update-doc form) and
    # bare `<repo>:<pattern>` (compact -fips update-doc form).
    TAG_PATTERN=$(grep -oE "[^[:space:]\"']+:[^[:space:] '\`)\"]*<ver>[^[:space:] '\`)\"]*" "$F" \
      | head -1 | sed -E 's|.*:||')
  fi

  if [ -z "$IMAGE_NAME" ] || [ -z "$TAG_PATTERN" ]; then
    echo "$IMG: pullImage present but couldn't parse imageName/tag pattern"
    revert; exit 1
  fi

  # `<ver>` and `<version>` in the pattern become the new version.
  NEW_TAG=$(printf '%s' "$TAG_PATTERN" | sed -e "s/<ver>/${NEW}/g" -e "s/<version>/${NEW}/g")

  echo "$IMG: pullImage — resolving digest for ${IMAGE_NAME}:${NEW_TAG}"
  if command -v skopeo >/dev/null 2>&1; then
    SKOPEO=(skopeo)
  else
    SKOPEO=(nix run nixpkgs#skopeo --)
  fi
  NEW_DIGEST=$("${SKOPEO[@]}" inspect --format '{{.Digest}}' \
    "docker://${IMAGE_NAME}:${NEW_TAG}" 2>/dev/null || true)
  if [ -z "$NEW_DIGEST" ]; then
    # try container-list index (linux/amd64)
    NEW_DIGEST=$("${SKOPEO[@]}" inspect --raw \
      "docker://${IMAGE_NAME}:${NEW_TAG}" 2>/dev/null \
      | jq -r '.manifests[]? | select(.platform.architecture == "amd64" and .platform.os == "linux") | .digest' \
      | head -1)
  fi
  if [ -z "$NEW_DIGEST" ]; then
    echo "$IMG: skopeo inspect failed for ${IMAGE_NAME}:${NEW_TAG}"
    revert; exit 1
  fi

  OLD_DIGEST=$(grep -oE 'imageDigest[[:space:]]*=[[:space:]]*"sha256:[a-f0-9]{64}"' "$F" \
    | head -1 | sed -E 's/.*"(sha256:[a-f0-9]{64})".*/\1/')
  if [ -z "$OLD_DIGEST" ]; then
    echo "$IMG: couldn't find existing imageDigest line"
    revert; exit 1
  fi
  sed -i "s|${OLD_DIGEST}|${NEW_DIGEST}|g" "$F"
  echo "$IMG: imageDigest ${OLD_DIGEST:0:19}... -> ${NEW_DIGEST:0:19}..."
fi

# 1c. per-arch hash attrset — e.g.
#        arch   = if isAarch64 then "arm64" else "x64";
#        hashes = { x64 = "sha256-…"; arm64 = "sha256-…"; };
#        src    = fetchurl { url = "…-${arch}-${version}.tar.gz"; hash = hashes.${arch}; };
#     The generic build loop below only builds x86_64-linux, so it exercises
#     (and repairs) exactly ONE arch's hash. The other arch's hash would never
#     be checked and would silently rot on every bump, breaking that image.
#     Prefetch each arch's hash directly from its concrete release URL — no
#     cross-arch build needed. Relies on the attr key (x64/arm64/…) being the
#     same string interpolated into the URL via `${arch}`, which is the
#     convention these definitions use.
if grep -qE '\$\{arch\}' "$F" \
   && grep -qE '^[[:space:]]*(x64|arm64|aarch64|amd64|x86_64)[[:space:]]*=[[:space:]]*"sha256-' "$F"; then
  URL_TMPL=$(grep -oE 'url[[:space:]]*=[[:space:]]*"[^"]+"' "$F" \
    | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -z "$URL_TMPL" ]; then
    echo "$IMG: per-arch hashes present but no url template found"
    revert; exit 1
  fi
  for key in $(grep -oE '^[[:space:]]*(x64|arm64|aarch64|amd64|x86_64)[[:space:]]*=[[:space:]]*"sha256-' "$F" \
                 | grep -oE '(x64|arm64|aarch64|amd64|x86_64)' | sort -u); do
    # substitute the nix interpolations we know how to resolve
    CU=$(printf '%s' "$URL_TMPL" | sed -e "s/\${version}/${NEW}/g" -e "s/\${arch}/${key}/g")
    NH=$(nix store prefetch-file --json --hash-type sha256 "$CU" 2>/dev/null | jq -r '.hash // empty')
    if [ -z "$NH" ]; then
      echo "$IMG: prefetch failed for arch=$key ($CU)"
      revert; exit 1
    fi
    sed -i -E "s|(^[[:space:]]*${key}[[:space:]]*=[[:space:]]*)\"sha256-[^\"]+\"|\1\"${NH}\"|" "$F"
    echo "$IMG: ${key} hash -> ${NH}"
  done
fi

# 2. iteratively repair hashes (src, then vendorHash, etc.)
for attempt in 1 2 3 4; do
  LOG=$(nix build "${STORE_ARG[@]}" ".#packages.${SYS}.\"${IMG}\"" "${LINK_ARG[@]}" --impure 2>&1)
  if [ $? -eq 0 ]; then
    echo "$IMG: $OLD -> $NEW (built OK)"
    exit 0
  fi
  # Nix reports:  specified: sha256-AAA...   got: sha256-REAL...
  GOT=$(printf '%s' "$LOG" | grep -oE 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' | head -1 | grep -oE 'sha256-[A-Za-z0-9+/=]+')
  if [ -n "$GOT" ]; then
    # replace whichever fake/old hash triggered this round
    SPEC=$(printf '%s' "$LOG" | grep -oE 'specified:[[:space:]]+sha256-[A-Za-z0-9+/=]+' | head -1 | grep -oE 'sha256-[A-Za-z0-9+/=]+')
    if [ -n "$SPEC" ] && grep -qF "$SPEC" "$F"; then
      sed -i "s|$SPEC|$GOT|g" "$F"
    else
      # first pass: blank the existing src hash to force a mismatch we can read
      perl -0pi -e "s/(hash|sha256)\\s*=\\s*\"sha256[-:][A-Za-z0-9+\\/=]+\"/\\1 = \"$FAKE\"/" "$F"
    fi
    continue
  fi
  # no hash mismatch in the log -> a real (non-hash) build failure
  echo "$IMG: build failed (not a hash issue):"
  printf '%s\n' "$LOG" | tail -4
  revert; exit 1
done
echo "$IMG: hash repair did not converge"
revert; exit 1
