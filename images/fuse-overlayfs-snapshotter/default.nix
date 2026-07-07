{ mkImage, pkgs, lib, ... }:

# fuse-overlayfs-snapshotter - https://github.com/containerd/fuse-overlayfs-snapshotter
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "2.1.7";
  drv = pkgs.buildGoModule {
    pname = "fuse-overlayfs-snapshotter";
    inherit version;
    src = pkgs.fetchFromGitHub {
      owner = "containerd"; repo = "fuse-overlayfs-snapshotter";
      rev = "v${version}"; hash = "sha256-w9v2OmgTxBmkZDXqXb2zfKb6o60F3X6qGd9+ZXk1lkk=";
    };
    vendorHash = "sha256-Ye2JVaf/wx/d4lCjnQmBquSkYkviNVKynDqKweKBtGI=";
    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";
    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };
in mkImage {
  inherit drv; name = "fuse-overlayfs-snapshotter"; tag = "v${version}";
  entrypoint = [ "${drv}/bin/containerd-fuse-overlayfs-grpc" ]; cmd = [ "--help" ];
  labels = { "org.opencontainers.image.title" = "fuse-overlayfs-snapshotter"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; };
}
