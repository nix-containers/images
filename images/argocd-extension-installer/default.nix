{ mkImage, fetchFromGitHub, buildGoModule, lib, ... }:

let
  version = "1.1.0";
  argocd-extension-installer = buildGoModule {
    pname = "argocd-extension-installer";
    inherit version;

    src = fetchFromGitHub {
      owner = "argoproj-labs";
      repo = "argocd-extension-installer";
      rev = "v${version}";
      hash = "sha256-NYBVT+q2GN5ZPjse911VzMV/D6fc9OGgwN+8bwypBh8=";
    };

    vendorHash = null;

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s" "-w"
      "-X main.version=${version}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "Argo CD extension installer for UI extensions";
      homepage = "https://github.com/argoproj-labs/argocd-extension-installer";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = argocd-extension-installer;
  name = "argocd-extension-installer";
  tag = "v${version}";
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "Argo CD Extension Installer";
    "org.opencontainers.image.description" = "UI extension installer for Argo CD";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "argocd";
  };
}
