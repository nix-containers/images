{ mkImage, pkgs, lib, ... }:

# azcopy - Azure Storage data transfer command-line utility
# https://github.com/Azure/azure-storage-azcopy
# -fips variant packages the upstream azcopy binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "10.32.5";

  drv = pkgs.buildGoModule {
    pname = "azcopy";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "Azure";
      repo = "azure-storage-azcopy";
      rev = "v${version}";
      hash = "sha256-wcJhKqc5MXUT8EWjmVoVAOwAc9alao9ReWE0LMVkt2g=";
    };

    proxyVendor = true;
    vendorHash = "sha256-4SY1u66BEG9xG/j2Ul+0f+UGEMkX9rkN8L0JVwrAjFQ=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      # buildGoModule installs from module name (azure-storage-azcopy)
      if [ -e $out/bin/azure-storage-azcopy ]; then
        mv $out/bin/azure-storage-azcopy $out/bin/azcopy
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "azcopy-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/azcopy" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "azcopy";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
