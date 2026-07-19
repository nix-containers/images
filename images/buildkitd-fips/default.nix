{ mkImage, pkgs, lib, ... }:

# buildkitd - concurrent, cache-efficient, and Dockerfile-agnostic builder daemon
# https://github.com/moby/buildkit
# -fips variant packages the upstream buildkitd binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.31.2";

  drv = pkgs.buildGoModule {
    pname = "buildkitd";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "moby";
      repo = "buildkit";
      rev = "v${version}";
      hash = "sha256-lpcbCPsnvwMULeZgo1eQ0AqlfsyOMO/7b3ZOCoVTDKk=";
    };

    vendorHash = null;

    subPackages = [ "cmd/buildkitd" "cmd/buildctl" ];
    ldflags = [ "-s" "-w" "-X github.com/moby/buildkit/version.Version=v${version}" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };

in mkImage {
  inherit drv;
  name = "buildkitd-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/buildkitd" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "buildkitd-fips";
    "org.opencontainers.image.description" = "BuildKit builder daemon (built from source)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
