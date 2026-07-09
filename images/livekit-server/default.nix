{ mkImage, pkgs, lib, ... }:

# LiveKit - open source WebRTC SFU server
# https://github.com/livekit/livekit
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.13.3";

  drv = pkgs.buildGoModule {
    pname = "livekit-server";
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
  name = "livekit-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/livekit-server" ];
  # Was `--help` (a one-shot, so the kind-test pod CrashLoops). Run the SFU:
  # --dev starts with built-in placeholder API keys (devkey/secret) so the bare
  # image needs no config or mounted secret, and --bind 0.0.0.0 makes the HTTP/
  # WebSocket signal server (:7880) + RTC TCP (:7881) reachable by the kind-test
  # probe. (Verified: the server stays up and listens on 0.0.0.0:7880/7881.)
  # Operators run production with their own --config / LIVEKIT_CONFIG (real API
  # keys, Redis, TURN) instead of --dev.
  cmd = [ "--dev" "--bind" "0.0.0.0" ];
  labels = {
    "org.opencontainers.image.title" = "livekit-server";
    "org.opencontainers.image.description" = "LiveKit open source WebRTC SFU server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
