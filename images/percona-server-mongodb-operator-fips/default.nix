{ nix2container, lib, pkgs, ... }:

# percona-server-mongodb-operator-fips — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/percona/percona-server-mongodb-operator:1.22.0
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "percona-server-mongodb-operator-fips";
  tag = "1.22.0";
  config.Labels = {
    "org.opencontainers.image.version" = "1.22.0";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/percona/percona-server-mongodb-operator:1.22.0 directly.";
    "io.nix-containers.upstream-image" = "docker.io/percona/percona-server-mongodb-operator:1.22.0";
    "io.nix-containers.image.upstream" = "docker.io/percona/percona-server-mongodb-operator";
  };
}
