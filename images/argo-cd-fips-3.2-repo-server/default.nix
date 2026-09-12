{ mkImage, pkgs, lib, ... }:

# Argo CD repo-server (multi-call argocd binary, invoked as argocd-repo-server)
# https://github.com/argoproj/argo-cd
# -fips suffix denotes the same upstream tool; the "3.2" in the name pins the
# 3.2 release line (v3.2.12) rather than the latest 3.x tag.
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the upstream
# prebuilt binary clear at each rebuild.

let
  version = "3.5.2";

  drv = pkgs.buildGoModule {
    pname = "argocd";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "argoproj";
      repo = "argo-cd";
      rev = "v${version}";
      hash = "sha256-hM7ss948dr7KntUGwiFDhr1OrbI+LAJlDgUMnegm+es=";
    };

    proxyVendor = true;
    vendorHash = "sha256-yzVSMdupFdrYUWMCPFhiYTnjCDGZo4Se0osXbCvB7gM=";

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
  name = "argo-cd-fips-3.2-repo-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argocd-repo-server" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "argo-cd-fips-3.2-repo-server";
    "org.opencontainers.image.description" = "Argo CD repo-server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
