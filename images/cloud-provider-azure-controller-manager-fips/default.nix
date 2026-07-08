{ mkImage, pkgs, lib, ... }:

# Azure cloud controller manager - Kubernetes cloud-provider for Azure
# https://github.com/kubernetes-sigs/cloud-provider-azure
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.36.3";

  drv = pkgs.buildGoModule {
    pname = "cloud-provider-azure-controller-manager-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "cloud-provider-azure";
      rev = "v${version}";
      hash = "sha256-O/ekGUrHFeJlXibtXZHVREzTKf4dauIMIcFQoUrjGUM=";
    };

    vendorHash = null;

    subPackages = [ "cmd/cloud-controller-manager" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/cloud-controller-manager ]; then
        mv $out/bin/cloud-controller-manager $out/bin/azure-cloud-controller-manager
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "cloud-provider-azure-controller-manager-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/azure-cloud-controller-manager" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cloud-provider-azure-controller-manager-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
