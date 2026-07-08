{ mkImage, pkgs, lib, ... }:

# Azure cloud node manager - Kubernetes cloud-provider for Azure
# https://github.com/kubernetes-sigs/cloud-provider-azure
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.36.3";

  drv = pkgs.buildGoModule {
    pname = "cloud-provider-azure-node-manager-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "cloud-provider-azure";
      rev = "v${version}";
      hash = "sha256-O/ekGUrHFeJlXibtXZHVREzTKf4dauIMIcFQoUrjGUM=";
    };

    vendorHash = null;

    subPackages = [ "cmd/cloud-node-manager" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/cloud-node-manager ]; then
        mv $out/bin/cloud-node-manager $out/bin/azure-cloud-node-manager
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "cloud-provider-azure-node-manager-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/azure-cloud-node-manager" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "cloud-provider-azure-node-manager-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
