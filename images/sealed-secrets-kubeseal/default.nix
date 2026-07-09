{ mkImage, pkgs, lib, ... }:

# kubeseal - client for Sealed Secrets
# https://github.com/bitnami-labs/sealed-secrets
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "0.38.1";

  drv = pkgs.buildGoModule {
    pname = "sealed-secrets-kubeseal";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "bitnami-labs";
      repo = "sealed-secrets";
      rev = "v${version}";
      hash = "sha256-a8D/k3Fxe/Im6tZqivvO9h/H4rVLZrHRli8xTHnDelI=";
    };

    proxyVendor = true;
    vendorHash = "sha256-H6zrymxNicGt9p2Uw3RZV6++AeWl+k5uTxKP7Y/ZLbg=";

    subPackages = [ "cmd/kubeseal" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Client tool for Sealed Secrets";
      homepage = "https://github.com/bitnami-labs/sealed-secrets";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "sealed-secrets-kubeseal";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/kubeseal" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "sealed-secrets-kubeseal";
    "org.opencontainers.image.description" = "Client (kubeseal) for Sealed Secrets";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
