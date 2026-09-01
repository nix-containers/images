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

  # 4. THE AGENT_IMAGE CONTRACT: /agent and /tini must execute in a
  #    FOREIGN container, not just in this one.
  #
  #    Test 2 above only proves the copy succeeds. It cannot catch the real
  #    failure, because it runs the binaries inside this image where
  #    /nix/store exists. In production the bootstrap init container copies
  #    them onto a shared emptyDir and the *workspace* container execs them
  #    -- and that is a different image entirely (pulumi/pulumi:<ver>-nonroot)
  #    with no /nix/store. A dynamically-linked binary's ELF interpreter
  #    (/nix/store/<hash>-glibc-*/lib/ld-linux-x86-64.so.2) is absent there,
  #    and Linux reports a missing interpreter as ENOENT -- so the symptom is
  #    "exec /share/tini: no such file or directory" for a file that is
  #    present and executable.
  #
  #    This shipped once (v2.9.0, dynamic tini) and wedged every Stack on a
  #    live cluster while every other assertion here passed.
  echo "  Checking /agent and /tini exec in a foreign container..."
  share=$(mktemp -d)
  # The image runs as UID 65532; the host temp dir is owned by the caller,
  # so make it writable for the copy-out step.
  ${pkgs.coreutils}/bin/chmod 777 "$share"
  docker run --rm -v "$share:/out" --entrypoint /bin/sh ${image.imageName}:test \
    -c 'cp /agent /tini /out/'

  # No chmod needed: the binaries come out of the image already mode 0555,
  # and they are owned by UID 65532 so the caller could not chmod them anyway.
  #
  # debian:12-slim stands in for the workspace image: glibc-based, no
  # /nix/store. Any non-nix base would do.
  if ! tv=$(docker run --rm -v "$share/tini:/share/tini:ro" debian:12-slim \
              /share/tini --version 2>&1); then
    echo "FAIL: /tini does not exec in a foreign container:"
    echo "  $tv"
    echo "tini must be statically linked (pkgs.pkgsStatic.tini) -- a nixpkgs"
    echo "dynamic build carries a /nix/store ELF interpreter that does not"
    echo "exist in the workspace image."
    rm -rf "$share"; exit 1
  fi
  echo "    tini in foreign container: $tv"

  if ! docker run --rm -v "$share/agent:/share/agent:ro" debian:12-slim \
         /share/agent --help >/dev/null 2>&1; then
    echo "FAIL: /agent does not exec in a foreign container."
    echo "It must stay a static build (buildGoModule with CGO_ENABLED=0)."
    rm -rf "$share"; exit 1
  fi
  echo "    agent in foreign container: ok"

  # 5. tini must CONSUME the `--` separator. The operator's workspace command
  #    is `/share/tini /share/agent -- serve --workspace ...`, with the `--`
  #    after the program name. Whether the child sees it depends on the
  #    libc's getopt: GNU permutes and eats it, musl (POSIX) preserves it.
  #    The agent is a cobra CLI and `agent -- serve` does NOT resolve the
  #    subcommand -- it prints help and exits 0, so the workspace container
  #    reports "Completed" while serving nothing and the Stack hangs forever
  #    with no error anywhere. A musl-static tini passes every other check
  #    here and still breaks the operator this way.
  echo "  Checking tini consumes the -- separator (glibc getopt semantics)..."
  argv=$(docker run --rm -v "$share/tini:/share/tini:ro" debian:12-slim \
           /share/tini /bin/echo "ARGV>" -- serve --workspace /tmp 2>&1 | tail -1)
  case "$argv" in
    "ARGV> serve --workspace /tmp")
      echo "    tini argv handling: ok" ;;
    *"-- serve"*)
      echo "FAIL: tini passed the '--' through to the child:"
      echo "  $argv"
      echo "This is musl/POSIX getopt behaviour. The agent is a cobra CLI and"
      echo "'agent -- serve' prints help and exits 0 instead of serving --"
      echo "the workspace pod Completes and the Stack hangs with no error."
      echo "Use the upstream glibc-built tini-static release binary."
      rm -rf "$share"; exit 1 ;;
    *)
      echo "FAIL: unexpected child argv from tini: $argv"
      rm -rf "$share"; exit 1 ;;
  esac
  rm -rf "$share"

  echo "All pulumi-kubernetes-operator tests passed!"
''
