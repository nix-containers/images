{ mkImage, pkgs, lib, ... }:

# Argo CD repo-server -fips variant (basename-dispatch on argocd binary)
# https://github.com/argoproj/argo-cd
# Same upstream tool as argocd-repo-server; no FIPS claim made.
#
# Built from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "3.4.4";

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
      ln -s argocd $out/bin/argocd-repo-server
    '';
  };
in mkImage {
  inherit drv;
  name = "argocd-repo-server-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argocd-repo-server" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "argocd-repo-server-fips";
    "org.opencontainers.image.description" = "Argo CD repo-server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
