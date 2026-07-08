{ mkImage, fetchFromGitHub, buildGoModule, lib, ... }:


# Chainguard SBOM packages for image-automation-controller:
# Packages NOT in nixpkgs:
#   flux-image-automation-controller (1.0.4-r3)

let
  version = "1.2.2";
  image-automation-controller = buildGoModule {
    pname = "image-automation-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "fluxcd";
      repo = "image-automation-controller";
      rev = "v${version}";
      hash = "sha256-bqYE2ahFYYAveziQXBSm3t6H9DqrpB1ZArR67uuFHwA=";
    };

    vendorHash = "sha256-ZrN+V0t4fIYDhEmBZrX8zRLv7LHtoy0HUnRvBwSBe04=";

    subPackages = [ "." ];

    env.CGO_ENABLED = 0;
    env.GOTOOLCHAIN = "local";

    ldflags = [
      "-s" "-w"
      "-X main.VERSION=${version}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "Flux image-automation-controller for automated image updates";
      homepage = "https://github.com/fluxcd/image-automation-controller";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = image-automation-controller;
  name = "image-automation-controller";
  tag = "v${version}";
  entrypoint = [ "${image-automation-controller}/bin/image-automation-controller" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "Flux Image Automation Controller";
    "org.opencontainers.image.description" = "Automates container image updates";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "flux2";
  };
}