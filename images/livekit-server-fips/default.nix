{ mkImage, pkgs, lib, ... }:

# LiveKit - open source WebRTC SFU server (-fips variant)
# https://github.com/livekit/livekit
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.13.3";

  drv = pkgs.buildGoModule {
    pname = "livekit-server-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "livekit";
      repo = "livekit";
      rev = "v${version}";
      hash = "sha256-Xv3jOHXYQfmDeqEWzAZmuhkhva5+NcVIMilaPTyfHpw=";
    };

    proxyVendor = true;
    vendorHash = "sha256-kDLmLIc01zoiBVnPtRPNV7La2hxkcnI6k1r1t/hVQLQ=";

    subPackages = [ "cmd/server" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/server ]; then
        mv $out/bin/server $out/bin/livekit-server
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "livekit-server-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/livekit-server" ];
  cmd = [ "--dev" "--bind" "0.0.0.0" ];
  labels = {
    "org.opencontainers.image.title" = "livekit-server-fips";
    "org.opencontainers.image.description" = "LiveKit open source WebRTC SFU server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
