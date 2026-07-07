#!/usr/bin/env bash
# update-image.sh <image>  — bump an image's def to latest upstream STABLE.
# Repeatable: resolves latest version, rewrites version + src hash (+ vendorHash
# for buildGoModule) via 2-phase fakeHash, builds to verify. Run on Linux (nix).
set -euo pipefail
img="${1:?usage: update-image.sh <image>}"
def="images/$img/default.nix"
info=$(bash scripts/image-latest-version.sh "$img" --json)
cur=$(printf '%s' "$info" | python3 -c 'import json,sys;print(json.load(sys.stdin)["current"])')
new=$(printf '%s' "$info" | python3 -c 'import json,sys;print(json.load(sys.stdin)["latest"])')
behind=$(printf '%s' "$info" | python3 -c 'import json,sys;print(json.load(sys.stdin)["behind"])')
[ "$behind" = "True" ] || [ "$behind" = "true" ] || { echo "$img: already latest ($cur)"; exit 0; }
echo "$img: $cur -> $new"
# bump version, reset hashes to fakeHash
sed -i "s/version = \"$cur\"/version = \"$new\"/" "$def"
sed -i -E 's/(hash = )"sha256-[A-Za-z0-9+/=]+"/\1lib.fakeHash/' "$def"
sed -i -E 's/(vendorHash = )"sha256-[A-Za-z0-9+/=]+"/\1lib.fakeHash/' "$def"
attr=".#packages.x86_64-linux.\"$img\""
# phase 1: src hash
sh=$(nix build "$attr" --no-link 2>&1 | grep -oE 'got:\s+sha256-[A-Za-z0-9+/=]+' | head -1 | grep -oE 'sha256-[A-Za-z0-9+/=]+')
[ -n "$sh" ] && sed -i -E "0,/hash = lib.fakeHash/s//hash = \"$sh\"/" "$def"
# phase 2: vendorHash (buildGoModule)
if grep -q 'vendorHash = lib.fakeHash' "$def"; then
  vh=$(nix build "$attr" --no-link 2>&1 | grep -oE 'got:\s+sha256-[A-Za-z0-9+/=]+' | head -1 | grep -oE 'sha256-[A-Za-z0-9+/=]+')
  [ -n "$vh" ] && sed -i "s/vendorHash = lib.fakeHash/vendorHash = \"$vh\"/" "$def"
fi
# final build check
if nix build "$attr" --no-link 2>/tmp/ui-$img.err; then echo "$img: BUILT at $new"; else echo "$img: BUILD FAILED (see /tmp/ui-$img.err)"; exit 1; fi
