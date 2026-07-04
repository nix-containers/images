{ mkImage, pkgs, lib, ... }:

# Rancher local-path-provisioner - dynamic local PV provisioner for Kubernetes
# https://github.com/rancher/local-path-provisioner
#
# Prior revision pinned to v0.0.26 (last release shipping a prebuilt amd64
# binary). Build from source with current nixpkgs Go so stdlib CVEs stay
# fresh and pick up upstream provisioner fixes.

let
  version = "0.0.36";

  drv = pkgs.buildGoModule {
    pname = "local-path-provisioner";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "rancher";
      repo = "local-path-provisioner";
      rev = "v${version}";
      hash = "sha256-pMcyabGJEdlV+CvdCjm0JcXUvWyNkdJRPEzVKIK7xOo=";
    };

    vendorHash = null;

    subPackages = [ "." ];

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "local-path-provisioner";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/local-path-provisioner" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "local-path-provisioner";
    "org.opencontainers.image.description" = "Rancher dynamic local path provisioner for Kubernetes";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
