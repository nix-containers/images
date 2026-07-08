{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Crossplane Provider — provider-gcp-container-fips
# https://github.com/crossplane-contrib/provider-upjet-gcp
#
# The legacy per-service crossplane-contrib/provider-<svc> repos no longer
# exist. Modern Crossplane packages all GCP services from a single
# monorepo (upjet family) that produces one `provider` binary.

let
  version = "2.6.0";
  provider = buildGoModule {
    pname = "provider-upjet-gcp";
    inherit version;

    src = fetchFromGitHub {
      owner = "crossplane-contrib";
      repo = "provider-upjet-gcp";
      rev = "v${version}";
      hash = "sha256-zdCbUs5QEb6T3SGja7twBLXOyd7GbpIrXNH7uMmJFd8=";
    };

    proxyVendor = true;
    vendorHash = "sha256-osE/n4zoJZ2x8KNwQvLXqeyXz2o2Km/DUMyrmIXa6cc=";

    subPackages = [ "cmd/provider" ];

    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;

    meta = with lib; {
      description = "Crossplane provider for GCP (upjet family)";
      homepage = "https://github.com/crossplane-contrib/provider-upjet-gcp";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = provider;
  name = "crossplane-provider-gcp-container-fips";
  tag = "v${version}";
  entrypoint = [ "${provider}/bin/provider" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "crossplane-provider-gcp-container-fips";
    "org.opencontainers.image.description" = "Crossplane GCP provider (from provider-upjet-gcp monorepo)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "crossplane";
  };
}
