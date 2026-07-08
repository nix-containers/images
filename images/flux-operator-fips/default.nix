{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# flux-operator-fips
# Flux GitOps component

let
  version = "0.54.1";
  flux-component = buildGoModule {
    pname = "flux-operator-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "controlplaneio-fluxcd";
      repo = "flux-operator";
      rev = "v0.54.1";
      hash = "sha256-9ZQosFR/FxTrGSWcbNyY3LHYOEFAi06MCOsoeDZLOmc=";
    };

    vendorHash = null;
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = flux-component;
  name = "flux-operator-fips";
  tag = "v${version}";
  entrypoint = [ "${flux-component}/bin/operator" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert git ];

  labels = {
    "org.opencontainers.image.title" = "flux operator";
    "org.opencontainers.image.description" = "Flux GitOps flux-operator";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "flux";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
