#!/usr/bin/env bash
# Batch-fix images with `vendorHash = null` that fail buildGoModule with
# "explicitly required in go.mod but not marked as explicit in vendor/modules.txt".
#
# Root cause: vendorHash=null makes buildGoModule use the source's stale
# vendored vendor/modules.txt. Setting a real vendorHash makes it vendor fresh.
#
# For each image: set vendorHash = lib.fakeHash, build to get the real hash,
# write it back. Run on a machine with the warm nix store (nixtop). Pass image
# names as args, or it scans a failure list file ($FAILED, default /tmp/failed-imgs.txt).
set -uo pipefail
SYS="${SYS:-x86_64-linux}"
imgs=("$@")
[ ${#imgs[@]} -eq 0 ] && mapfile -t imgs < <(sort -u "${FAILED:-/tmp/failed-imgs.txt}" 2>/dev/null)
fixed=0; skipped=0; failed=0
for img in "${imgs[@]}"; do
  f="images/$img/default.nix"
  grep -qs 'vendorHash = null' "$f" || { skipped=$((skipped+1)); continue; }
  echo "==> $img: null -> fakeHash, building for real hash"
  sed -i.bak 's/vendorHash = null;.*/vendorHash = lib.fakeHash;/' "$f"
  got=$(nix build ".#packages.${SYS}.\"$img\"" --no-link 2>&1 \
        | grep -oE 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' | head -1 | grep -oE 'sha256-[A-Za-z0-9+/=]+')
  if [ -n "$got" ]; then
    sed -i "s#vendorHash = lib.fakeHash;#vendorHash = \"$got\";#" "$f"
    rm -f "$f.bak"
    # verify it actually builds now
    if nix build ".#packages.${SYS}.\"$img\"" --no-link >/dev/null 2>&1; then
      echo "    OK $img -> $got"; fixed=$((fixed+1))
    else
      echo "    HASH set but still fails (deeper issue) $img"; failed=$((failed+1))
    fi
  else
    mv "$f.bak" "$f"; echo "    no got-hash (not a simple vendor issue) $img"; failed=$((failed+1))
  fi
done
echo "=== fixed=$fixed skipped=$skipped failed=$failed ==="
