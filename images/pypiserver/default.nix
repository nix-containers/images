{ mkImage, pkgs, lib, ... }:

# PyPI Server - Minimal PyPI server
# https://github.com/pypiserver/pypiserver

let
  # passwd entry for the running uid (65532). pypiserver is a Python app and the
  # runtime may resolve the uid (pwd.getpwuid) at startup; mkImage ships no
  # /etc/passwd. Passwd-only derivation (just /etc) to avoid colliding with
  # mkImage's writable /tmp layer; HOME=/tmp keeps any caches writable.
  passwdEnv = pkgs.runCommand "pypiserver-passwd" {} ''
    mkdir -p $out/etc
    printf 'root:x:0:0:root:/root:/sbin/nologin\nnonroot:x:65532:65532:nonroot:/tmp:/sbin/nologin\n' > $out/etc/passwd
    printf 'root:x:0:\nnonroot:x:65532:\n' > $out/etc/group
  '';

in
mkImage {
  drv = pkgs.pypiserver;
  name = "pypiserver";
  tag = "v${pkgs.pypiserver.version}";
  entrypoint = [ "${pkgs.pypiserver}/bin/pypi-server" ];
  # Was `--help` (a one-shot). Serve on 0.0.0.0:8080 from the writable /tmp
  # package dir mkImage provides, fully anonymous (-a . -P .) for smoke-test
  # use. Operators mount a real package dir and add auth (-a update -P htpasswd).
  cmd = [ "run" "-p" "8080" "-a" "." "-P" "." "/tmp" ];
  env = {
    HOME = "/tmp";
  };

  extraPkgs = [ pkgs.cacert passwdEnv ];

  labels = {
    "org.opencontainers.image.title" = "PyPI Server";
    "org.opencontainers.image.description" = "Minimal PyPI-compatible server";
    "org.opencontainers.image.version" = pkgs.pypiserver.version;
    "io.nix-containers.image.upstream" = "https://github.com/pypiserver/pypiserver";
    "io.nix-containers.image.category" = "web-service";
    "io.nix-containers.image.aliases" = "pypiserver,pypi-server,pypi";
  };
}
