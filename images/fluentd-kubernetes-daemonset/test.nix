{ pkgs, image }:

pkgs.writeShellScript "test-fluentd-kubernetes-daemonset" ''
  set -euo pipefail
  echo "Testing fluentd-kubernetes-daemonset image functionality..."

  # Test 1: Version check
  echo "  Testing fluentd version..."
  docker run --rm --entrypoint fluentd ${image.imageName}:test --version 2>&1 | grep -qE "fluentd [0-9]+\.[0-9]+"

  # Test 2: Help output
  echo "  Testing fluentd help..."
  docker run --rm --entrypoint fluentd ${image.imageName}:test --help 2>&1 | grep -q "fluentd"

  # Test 3: Binary exists
  echo "  Testing fluentd binary exists..."
  docker run --rm --entrypoint /bin/sh ${image.imageName}:test -c "ls /nix/store/*/bin/fluentd" 2>&1 | grep -q "fluentd"

  echo "All fluentd-kubernetes-daemonset tests passed!"
''
