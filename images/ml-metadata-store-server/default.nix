{ nix2container, lib, pkgs, ... }:

# ml-metadata-store-server — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: gcr.io/tfx-oss-public/ml_metadata_store_server:v0.22.1
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "ml-metadata-store-server";
  tag = "v0.22.1";
  config.Labels = {
    "org.opencontainers.image.version" = "v0.22.1";
    "org.opencontainers.image.description" = "Upstream reference — pull gcr.io/tfx-oss-public/ml_metadata_store_server:v0.22.1 directly.";
    "io.nix-containers.upstream-image" = "gcr.io/tfx-oss-public/ml_metadata_store_server:v0.22.1";
    "io.nix-containers.image.upstream" = "gcr.io/tfx-oss-public/ml_metadata_store_server";
  };
}
