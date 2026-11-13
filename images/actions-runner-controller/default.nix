{ mkImage, pkgs, lib, fetchFromGitHub, buildGoModule, ... }:

# Actions Runner Controller (ARC) - Kubernetes operator for GitHub Actions self-hosted runners
# https://github.com/actions/actions-runner-controller

let
  version = "0.15.1";

  actions-runner-controller = buildGoModule rec {
    pname = "actions-runner-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "actions";
      repo = "actions-runner-controller";
      rev = "gha-runner-scale-set-${version}";
      hash = "sha256-kkwWr/LpD9ggMGye+aeBgHUWWM9aV2os3fYAVgG/J2Y=";
    };

    vendorHash = "sha256-mWQOyfWxazkxDxYyN4qdcyy0t0UWBSiqQ9hHIzzdq0A=";

    subPackages = [ "." ];

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s" "-w"
      "-X main.version=${version}"
    ];

    doCheck = false;

    # Rename the binary from actions-runner-controller to manager (the actual binary name)
    postInstall = ''
      mv $out/bin/actions-runner-controller $out/bin/manager
    '';

    meta = with lib; {
      description = "Kubernetes operator for orchestrating GitHub Actions self-hosted runners";
      homepage = "https://github.com/actions/actions-runner-controller";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

in
mkImage {
  drv = actions-runner-controller;
  name = "actions-runner-controller";
  tag = "v${version}";
  entrypoint = [ "${actions-runner-controller}/bin/manager" ];
  cmd = [];

  extraPkgs = with pkgs; [
    cacert
  ];

  labels = {
    "org.opencontainers.image.title" = "Actions Runner Controller";
    "org.opencontainers.image.description" = "Kubernetes operator for orchestrating GitHub Actions self-hosted runners";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "actions-runner-controller";
  };
}
