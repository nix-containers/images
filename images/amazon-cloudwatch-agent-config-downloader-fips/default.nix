{ nix2container, lib, pkgs, ... }:

# amazon-cloudwatch-agent-config-downloader-fips — UPSTREAM REFERENCE (not built/hosted). Use public.ecr.aws/cloudwatch-agent/cloudwatch-agent:1.300041.0b681 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "amazon-cloudwatch-agent-config-downloader-fips";
  tag = "1.300041.0b681";
  config.Labels = {
    "org.opencontainers.image.version" = "1.300041.0b681";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/cloudwatch-agent/cloudwatch-agent:1.300041.0b681 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent:1.300041.0b681";
    "io.nix-containers.image.upstream" = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent";
  };
}
