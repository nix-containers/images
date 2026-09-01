{ pkgs, image }:

pkgs.writeShellScript "test-pulumi-kubernetes-operator" ''
  set -euo pipefail
  echo "Testing pulumi-kubernetes-operator image..."

  # 1. Entrypoint contract. The chart passes args
  #    ["/manager", "--leader-elect", ...] and operator/cmd/main.go parses
  #    with the stdlib `flag` package, which STOPS at the first non-flag
  #    argument. If the image entrypoint is the manager binary rather than
  #    ["/tini","--"], argv becomes `manager /manager --help`, --help is
  #    never processed, and no usage is printed. Assert we see the flags.
  echo "  Checking entrypoint does not swallow chart args..."
  out=$(docker run --rm ${image.imageName}:test /manager --help 2>&1 || true)
  echo "$out" | grep -q -- "-leader-elect" || {
    echo "FAIL: '/manager --help' through the entrypoint did not list -leader-elect."
    echo "The entrypoint is likely the manager binary instead of [/tini --]."
    echo "$out" | head -20
    exit 1
  }

  # 2. Bootstrap init container payload. The operator runs this exact cp for
  #    every Stack; missing /agent or /tini means no Stack can reconcile.
  echo "  Checking /agent and /tini are present and copyable..."
  docker run --rm --entrypoint /bin/sh ${image.imageName}:test \
    -c 'mkdir -p /tmp/share && cp /agent /tini /tmp/share/ && test -x /tmp/share/agent && test -x /tmp/share/tini'

  # 3. Chart-hardcoded /manager path.
  echo "  Checking /manager is present..."
  docker run --rm --entrypoint /bin/sh ${image.imageName}:test -c 'test -x /manager'

  echo "All pulumi-kubernetes-operator tests passed!"
''
