{ mkImage, pkgs, lib, ... }:

# helm-mapkubeapis - Helm plugin to migrate deprecated Kubernetes APIs
# https://github.com/helm/helm-mapkubeapis
#
# Prior revision consumed the upstream prebuilt tarball, which is
# Go-stdlib v1.24.0 stale (crit CVEs). Rebuild from source with the
# current nixpkgs Go toolchain.

let
  version = "0.6.1";

  drv = pkgs.buildGoModule {
    pname = "helm-mapkubeapis";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "helm";
      repo = "helm-mapkubeapis";
      rev = "v${version}";
      hash = "sha256-RvyoqfhvoXESmc6M4B1XeUtal0zQt6LCKjByyBe6pUU=";
    };

    # Upstream vendor/modules.txt drifts from go.mod; use proxyVendor to
    # re-fetch modules through the Go proxy instead of the committed tree.
    proxyVendor = true;
    vendorHash = "sha256-nYYDRk/ivFXDDpBWV6yevo7LncbHZt3ivEIleGrQFb0=";

    subPackages = [ "cmd/mapkubeapis" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    env.GOTOOLCHAIN = "local";
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "helm-mapkubeapis";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/mapkubeapis" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "helm-mapkubeapis";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
