{ pkgs, image }:

pkgs.writeShellScript "test-os-shell" ''
  set -euo pipefail
  img=${image.imageName}:test

  docker run --rm "$img" /bin/bash -ec 'echo ok' | grep -qx ok
  docker run --rm "$img" /bin/bash -ec 'command -v sysctl ls cat' >/dev/null
  docker run --rm "$img" /bin/bash -ec 'sysctl -n vm.max_map_count' | grep -Eq '^[0-9]+$'
  docker run --rm "$img" /bin/bash -ec 'id -u' | grep -qx 1001

  echo "os-shell tests passed"
''
