#!/bin/sh
# Regression checks for pulumi-kubernetes-operator.
#
# History of what this image has gotten wrong, each assert below maps to one:
#   - Pre-PR-47: a STUB with no operator binary at all. The chart's
#     `command: ["/manager"]` failed with "no such file or directory".
#   - Through v2.7.0: no /agent and no /tini. The chart sets AGENT_IMAGE to
#     this image, and the operator runs `cp /agent /tini /share/` from it as
#     the bootstrap init container for EVERY Stack. Both missing meant no
#     Stack could reconcile -- while the controller itself looked healthy.
#
# NOTE: the kind harness runs this with the Pod's command overridden, so the
# image Entrypoint is bypassed here. The entrypoint/args contract is tested in
# test.nix instead, which uses `docker run` against the real entrypoint.
set -eu
. /smoketest/helpers.sh

# 1) Chart hardcodes `/manager` in args.
assert_chart_cmd_paths /manager

# 2) Bootstrap init container copies these two out to the shared volume.
assert_chart_cmd_paths /agent /tini

# 3) The bootstrap `cp` must actually succeed, not just find the paths.
mkdir -p /tmp/share
cp /agent /tini /tmp/share/ || {
  echo "ASSERT FAIL: bootstrap 'cp /agent /tini /share/' failed"
  exit 1
}

# 4) The binary is the real operator, not a placeholder.
out=$(/manager --help 2>&1 || true)
case "$out" in
  *kubeconfig*controller*|*"Usage of /manager"*|*leader-elect*)
    :
    ;;
  *)
    echo "ASSERT FAIL: /manager doesn't look like the operator binary"
    echo "$out" | head -5
    exit 1
    ;;
esac

# 5) The agent binary is the real agent -- it must expose the `serve`
#    subcommand the workspace pod invokes.
aout=$(/agent --help 2>&1 || true)
case "$aout" in
  *serve*)
    :
    ;;
  *)
    echo "ASSERT FAIL: /agent has no 'serve' subcommand"
    echo "$aout" | head -5
    exit 1
    ;;
esac

echo "ok"
