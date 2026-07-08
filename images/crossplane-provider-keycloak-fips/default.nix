{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Crossplane Provider - keycloak
# https://github.com/crossplane-contrib/provider-keycloak

let
  version = "2.22.1";
  provider-keycloak = buildGoModule {
    pname = "provider-keycloak-fips";
    inherit version;

    src = fetchFromGitHub {
      owner = "crossplane-contrib";
      repo = "provider-keycloak";
      rev = "v${version}";
      hash = "sha256-cPxKP4baeuxaRbs17Xt9/AXDFVPu9teHgQszGy8ePbE=";
    };

    vendorHash = "sha256-1keKb9nAkVGf5XhCUQy/ohk92ouBI2ck2BUGCzO21Zc=";

    subPackages = [ "cmd/provider" ];

    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";

    ldflags = [ "-s" "-w" ];
    doCheck = false;

    meta = with lib; {
      description = "Crossplane provider for keycloak";
      homepage = "https://github.com/crossplane-contrib/provider-keycloak";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = provider-keycloak;
  name = "crossplane-provider-keycloak-fips";
  tag = "v${version}";
  entrypoint = [ "${provider-keycloak}/bin/provider" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "Crossplane Provider keycloak";
    "org.opencontainers.image.description" = "Crossplane provider for keycloak";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "crossplane";
    "io.nix-containers.compliance" = "FIPS-140-2";
  };
}
