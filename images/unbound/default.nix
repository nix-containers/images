{ mkImage, pkgs, nonRoot, ... }:

# unbound - validating, recursive, caching DNS resolver
# https://nlnetlabs.nl/projects/unbound/

let
  # /etc/passwd entry for the nonroot (65532) user. unbound drops privileges to
  # its configured `username` at startup and fatals if that user can't be
  # resolved; mkImage ships no passwd, so provide one and point unbound at the
  # same user it already runs as (setuid to your own uid is a no-op).
  userEnv = nonRoot.mkDefaultUserEnv pkgs [];

  # Minimal non-root resolver config. The stub ran `unbound --help` (a one-shot,
  # not a server). Listen on 0.0.0.0:5353 (>1024 so the nonroot user can bind;
  # operators wanting :53 add NET_BIND_SERVICE / run as root), no chroot (can't
  # as non-root), drop to the nonroot user (already the running uid), pid +
  # working dir on the writable /tmp mkImage provides, iterator-only so no
  # DNSSEC trust-anchor file is needed (recursive resolution uses unbound's
  # built-in root hints). Operators override by mounting their own config.
  unboundConfig = pkgs.writeTextDir "etc/unbound/unbound.conf" ''
    server:
        verbosity: 1
        interface: 0.0.0.0
        port: 5353
        do-daemonize: no
        access-control: 0.0.0.0/0 allow
        chroot: ""
        username: "nonroot"
        directory: "/tmp"
        pidfile: "/tmp/unbound.pid"
        use-syslog: no
        logfile: ""
        module-config: "iterator"
  '';

in
mkImage {
  drv = pkgs.unbound;
  name = "unbound";
  # Version-tag the image (matches the org.opencontainers.image.version label).
  tag = pkgs.unbound.version;

  # Run the resolver in the foreground (-d) with the baked config so the kind
  # probe reaches a Running pod (was `unbound --help`, a one-shot).
  entrypoint = [ "unbound" ];
  cmd = [ "-d" "-c" "/etc/unbound/unbound.conf" ];
  extraContents = [ unboundConfig userEnv ];

  labels = {
    "org.opencontainers.image.title" = "unbound";
    "org.opencontainers.image.description" = "Validating, recursive, caching DNS resolver";
    "org.opencontainers.image.version" = pkgs.unbound.version;
    "io.nix-containers.image.upstream" = "https://nlnetlabs.nl/projects/unbound/";
    "io.nix-containers.image.category" = "networking";
    "io.nix-containers.image.aliases" = "unbound,dns,resolver";
  };

  user = nonRoot.userString;
}
