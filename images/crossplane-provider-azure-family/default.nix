{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Crossplane Provider — provider-azure-family
# https://github.com/crossplane-contrib/provider-upjet-azure
#
# The legacy per-service crossplane-contrib/provider-<svc> repos no longer
# exist. Modern Crossplane packages all AZURE services from a single
# monorepo (upjet family) that produces one `provider` binary.

let
  version = "2.6.0";
  provider = buildGoModule {
    pname = "provider-upjet-azure";
    inherit version;

    src = fetchFromGitHub {
      owner = "crossplane-contrib";
      repo = "provider-upjet-azure";
      rev = "v${version}";
      hash = "sha256-BwmM9nCFYFRzCAcmDDBn6mYgfr3IvzAQrqPdan0RnDM=";
    };

    proxyVendor = true;
    vendorHash = "sha256-3aU9sFkbYNdfLLR8fL4/osb1eiZAZVbCojUMIWby1ZA=";

    subPackages = [ "cmd/provider" ];

    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;

    meta = with lib; {
      description = "Crossplane provider for AZURE (upjet family)";
      homepage = "https://github.com/crossplane-contrib/provider-upjet-azure";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = provider;
  name = "crossplane-provider-azure-family";
  tag = "v${version}";
  entrypoint = [ "${provider}/bin/provider" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "crossplane-provider-azure-family";
    "org.opencontainers.image.description" = "Crossplane AZURE provider (from provider-upjet-azure monorepo)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "crossplane";
  };
}
