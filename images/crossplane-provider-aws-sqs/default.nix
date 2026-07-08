{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Crossplane Provider - provider-aws-sqs
# https://github.com/crossplane-contrib/provider-upjet-aws
#
# The legacy per-service crossplane-contrib/provider-<svc> repos no longer
# exist. Modern Crossplane packages all AWS services from a single monorepo
# (provider-upjet-aws) that produces one `provider` binary. The runtime
# selects the service at deploy time; this image bundles that binary under
# a stable name for consumers referencing the historical path.

let
  version = "2.6.0";
  provider = buildGoModule {
    pname = "provider-upjet-aws";
    inherit version;

    src = fetchFromGitHub {
      owner = "crossplane-contrib";
      repo = "provider-upjet-aws";
      rev = "v${version}";
      hash = "sha256-yQLnXa5kx2/v4YXsnupRTqZptTUW2xz3YvzVmbYkC9o=";
    };

    proxyVendor = true;
    vendorHash = "sha256-4GBzXNjTAQlDLNgeDZpeIm7sJCPpjFUfzL+XsX0JVs4=";

    subPackages = [ "cmd/provider" ];

    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;

    meta = with lib; {
      description = "Crossplane provider for AWS (upjet family)";
      homepage = "https://github.com/crossplane-contrib/provider-upjet-aws";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = provider;
  name = "crossplane-provider-aws-sqs";
  tag = "v${version}";
  entrypoint = [ "${provider}/bin/provider" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "crossplane-provider-aws-sqs";
    "org.opencontainers.image.description" = "Crossplane provider for AWS (from provider-upjet-aws monorepo)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "crossplane";
  };
}
