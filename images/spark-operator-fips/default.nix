{ nix2container, lib, pkgs, ... }:

# spark-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use ghcr.io/kubeflow/spark-operator/controller:2.5.1 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "spark-operator-fips";
  tag = "2.5.1";
  config.Labels = {
    "org.opencontainers.image.version" = "2.5.1";
    "org.opencontainers.image.description" = "Upstream reference — pull ghcr.io/kubeflow/spark-operator/controller:2.5.1 directly.";
    "io.nix-containers.upstream-image" = "ghcr.io/kubeflow/spark-operator/controller:2.5.1";
    "io.nix-containers.image.upstream" = "ghcr.io/kubeflow/spark-operator/controller";
  };
}
