{ nix2container, lib, pkgs, ... }:

# distroless — UPSTREAM REFERENCE (not built/hosted). Use gcr.io/distroless/static:latest directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "distroless";
  tag = "latest";
  config.Labels = {
    "org.opencontainers.image.version" = "latest";
    "org.opencontainers.image.description" = "Upstream reference — pull gcr.io/distroless/static:latest directly.";
    "io.nix-containers.upstream-image" = "gcr.io/distroless/static:latest";
    "io.nix-containers.image.upstream" = "gcr.io/distroless/static";
  };
}
