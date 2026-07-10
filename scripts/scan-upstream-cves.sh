#!/usr/bin/env bash
# Regenerate data/clean-upstream-status.json — the source of the golden
# "★ 0 CVE upstream" badge.
#
# For every image def that references an official upstream image (the
# io.nix-containers.upstream-image label), scan that upstream image with trivy
# and record its CVE counts. An image qualifies for the badge when its upstream
# scans clean:  total == 0  OR  0 critical/high/medium (only low/unknown).
#
# Run on a host with network + trivy (e.g. the nixtop, trivy via nix). Read-only
# against the repo; writes only data/clean-upstream-status.json.
#
# Usage:  scripts/scan-upstream-cves.sh [--parallel N]
set -euo pipefail
cd "$(dirname "$0")/.."

PAR=3
[ "${1:-}" = "--parallel" ] && PAR="${2:-3}"

TRIVY="$(command -v trivy || true)"
if [ -z "$TRIVY" ]; then
  TRIVY="$(nix build --no-link --print-out-paths nixpkgs#trivy 2>/dev/null)/bin/trivy"
fi
[ -x "$TRIVY" ] || { echo "trivy not found (install it or run where nix can build nixpkgs#trivy)"; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
pairs="$work/pairs.csv"        # image,ref
results="$work/results.csv"    # ref,crit,high,med,low,unk,total,tier
: > "$pairs"; : > "$results"

# 1. Extract image -> upstream-image ref from every def that has the label.
for f in images/*/default.nix; do
  ref=$(grep -oE '"io\.nix-containers\.upstream-image"[[:space:]]*=[[:space:]]*"[^"]+"' "$f" 2>/dev/null \
          | grep -oE '"[^"]+"$' | tr -d '"')
  [ -z "$ref" ] && continue
  echo "$(basename "$(dirname "$f")"),$ref" >> "$pairs"
done
echo "$(date '+%T') extracted $(wc -l < "$pairs") image/upstream pairs"

# 2. Scan each unique upstream ref with trivy.
"$TRIVY" image --download-db-only 2>/dev/null || true
scan_ref() {
  local ref="$1" j crit high med low unk total tier a
  for a in 1 2; do
    j=$(timeout 480 "$TRIVY" image --quiet --scanners vuln --format json \
          --severity CRITICAL,HIGH,MEDIUM,LOW,UNKNOWN "$ref" 2>/dev/null) && [ -n "$j" ] && break
    sleep $((a*15))
  done
  [ -z "$j" ] && { echo "$ref,,,,,,,unreachable" >> "$RESULTS"; return; }
  crit=$(printf '%s' "$j" | jq '[.Results[]?.Vulnerabilities[]?|select(.Severity=="CRITICAL")]|length')
  high=$(printf '%s' "$j" | jq '[.Results[]?.Vulnerabilities[]?|select(.Severity=="HIGH")]|length')
  med=$(printf '%s'  "$j" | jq '[.Results[]?.Vulnerabilities[]?|select(.Severity=="MEDIUM")]|length')
  low=$(printf '%s'  "$j" | jq '[.Results[]?.Vulnerabilities[]?|select(.Severity=="LOW")]|length')
  unk=$(printf '%s'  "$j" | jq '[.Results[]?.Vulnerabilities[]?|select(.Severity=="UNKNOWN")]|length')
  [ -z "$crit" ] && { echo "$ref,,,,,,,parse-error" >> "$RESULTS"; return; }
  total=$((crit+high+med+low+unk))
  if   [ "$total" -eq 0 ];                               then tier="strict"
  elif [ "$crit" -eq 0 ] && [ "$high" -eq 0 ] && [ "$med" -eq 0 ]; then tier="relaxed"
  else tier="none"; fi
  echo "$ref,$crit,$high,$med,$low,$unk,$total,$tier" >> "$RESULTS"
  echo "  [$ref] c=$crit h=$high m=$med total=$total $tier" >&2
}
export -f scan_ref; export RESULTS="$results" TRIVY
cut -d, -f2 "$pairs" | sort -u | tr '\n' '\0' | xargs -0 -P "$PAR" -I {} bash -c 'scan_ref "$@"' _ {}
echo "$(date '+%T') scanned $(wc -l < "$results") unique refs"

# 3. Emit data/clean-upstream-status.json (qualifying images only).
GEN_DATE="${GEN_DATE:-$(date -u +%Y-%m-%d)}" python3 - "$pairs" "$results" <<'PY'
import csv, json, os, sys
pairs, results = sys.argv[1], sys.argv[2]
by_ref = {}
with open(results) as f:
    for r in csv.reader(f):
        ref, crit, high, med, low, unk, total, tier = (r + [""]*8)[:8]
        if tier in ("strict", "relaxed"):
            by_ref[ref] = dict(ref=ref, total=int(total), critical=int(crit),
                               high=int(high), medium=int(med), tier=tier)
images = {}
with open(pairs) as f:
    for img, ref in csv.reader(f):
        if ref in by_ref:
            images[img] = {"upstreamZeroCve": True, **by_ref[ref]}
out = {
    "generatedAt": os.environ["GEN_DATE"],
    "method": "trivy image scan of each project's official upstream image; "
              "qualifies at total==0 or 0 critical/high/medium",
    "images": dict(sorted(images.items())),
}
with open("data/clean-upstream-status.json", "w") as f:
    json.dump(out, f, indent=2)
    f.write("\n")
strict = sum(1 for v in images.values() if v["tier"] == "strict")
print(f"wrote {len(images)} images to data/clean-upstream-status.json "
      f"({strict} strict / {len(images)-strict} relaxed)")
PY
