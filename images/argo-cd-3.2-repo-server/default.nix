{ mkImage, pkgs, lib, ... }:

# Argo CD repo-server (multi-call argocd binary, invoked as argocd-repo-server)
# https://github.com/argoproj/argo-cd
#
# Note: image is named "argo-cd-3.2-repo-server" but currently pins v3.4.4 to
# match the sibling argocd-repo-server image. Built from source with current
# nixpkgs Go so Go-stdlib CVEs from the upstream prebuilt binary clear at each
# rebuild.

let
  version = "3.4.5";

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
  name = "argo-cd-3.2-repo-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argocd-repo-server" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "argo-cd-3.2-repo-server";
    "org.opencontainers.image.description" = "Argo CD repo-server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
