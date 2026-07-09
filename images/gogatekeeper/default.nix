{ mkImage, pkgs, lib, ... }:

# gogatekeeper / gatekeeper - OAuth2/OIDC reverse proxy
# https://github.com/gogatekeeper/gatekeeper
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "4.10.0";

  drv = pkgs.buildGoModule {
    pname = "gatekeeper";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "gogatekeeper";
      repo = "gatekeeper";
      rev = version;
      hash = "sha256-dD0byJ2gLpFnd39n6w7bzjaZNzrgye/iWAtqXnWi3RM=";
    };

    proxyVendor = true;
    vendorHash = "sha256-1H4s8QkEWH5Zd9IUOGGT5sp4bUVwsAVhzQ7Y9XkKgqw=";

    subPackages = [ "cmd/keycloak" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/keycloak ]; then
        mv $out/bin/keycloak $out/bin/gatekeeper
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "gogatekeeper";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/gatekeeper" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "gogatekeeper";
    "org.opencontainers.image.description" = "OAuth2/OIDC reverse proxy (Gatekeeper)";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
