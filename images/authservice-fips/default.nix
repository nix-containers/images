{ mkImage, pkgs, lib, ... }:

# authservice - external authorization server for Envoy (OIDC/OAuth2)
# https://github.com/istio-ecosystem/authservice
# -fips variant packages the upstream authservice binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.1.8";

  drv = pkgs.buildGoModule {
    pname = "authservice-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "istio-ecosystem";
      repo = "authservice";
      rev = "v${version}";
      hash = "sha256-nlTBoXqkkkyzIBD/+eqkHKelZ0IE76RS1JK3kXlnVsI=";
    };

    proxyVendor = true;
    vendorHash = "sha256-ytiF+J4YcRCEC1pqTuP7C5ul1m7klRDRqFeO2culjPg=";

    subPackages = [ "cmd" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      mv $out/bin/cmd $out/bin/authservice
    '';
  };
in mkImage {
  inherit drv;
  name = "authservice-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/authservice" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "authservice-fips";
    "org.opencontainers.image.description" = "External authorization server for Envoy (OIDC/OAuth2)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
