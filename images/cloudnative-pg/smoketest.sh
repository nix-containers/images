#!/bin/sh
# Regression check for the chart-cmd-path bug pattern. The
# cloudnative-pg helm chart hardcodes `command: ["/manager"]` on the
# operator Deployment; without a `/manager` symlink the pod fails at
# start with `exec: "/manager": no such file or directory`.
set -eu
. /smoketest/helpers.sh

assert_chart_cmd_paths /manager

archs=$(/manager debug show-architectures)
echo "show-architectures: $archs"
case "$archs" in
  *'"'*) ;;
  *) echo "FAIL: no operator/manager_<arch> binaries found" >&2; exit 1 ;;
esac
echo "ok"
