{ mkImage, pkgs, lib, ... }:

# Argo CD CLI (-fips variant) - built from source
# https://github.com/argoproj/argo-cd
# Same upstream tool as argo-cd; no FIPS claim made.
#
# Built from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "3.5.2";

  drv = pkgs.buildGoModule {
    pname = "argocd";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "argoproj";
      repo = "argo-cd";
      rev = "v${version}";
      hash = "sha256-I3udVhmPpOA2Lf1mkJqG+d+mGpfM16HIKBkEnTiAw0c=";
    };

    proxyVendor = true;
    vendorHash = "sha256-w6jFNWKvcwxyeiSy+Pqb43qOfMOXF5UHr2VpyQD2dFw=";

    subPackages = [ "cmd" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      mv $out/bin/cmd $out/bin/argocd
    '';
  };
in mkImage {
  inherit drv;
  name = "argo-cd-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argocd" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "argo-cd-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
