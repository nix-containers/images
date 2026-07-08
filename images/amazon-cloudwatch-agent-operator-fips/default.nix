{ nix2container, lib, pkgs, ... }:

# amazon-cloudwatch-agent-operator-fips — UPSTREAM REFERENCE (not built/hosted). Use public.ecr.aws/cloudwatch-agent/cloudwatch-agent-operator:3.2.0 directly.
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "amazon-cloudwatch-agent-operator-fips";
  tag = "3.2.0";
  config.Labels = {
    "org.opencontainers.image.version" = "3.2.0";
    "org.opencontainers.image.description" = "Upstream reference — pull public.ecr.aws/cloudwatch-agent/cloudwatch-agent-operator:3.2.0 directly.";
    "io.nix-containers.upstream-image" = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent-operator:3.2.0";
    "io.nix-containers.image.upstream" = "public.ecr.aws/cloudwatch-agent/cloudwatch-agent-operator";
  };
}
