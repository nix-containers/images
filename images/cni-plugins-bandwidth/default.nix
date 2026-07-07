{ mkImage, pkgs, lib, ... }:

# CNI bandwidth plugin (from containernetworking/plugins)
# https://github.com/containernetworking/plugins
#
# Rebuilt from source with current nixpkgs Go so stdlib CVEs from the
# upstream prebuilt tarball clear at each rebuild.

let
  version = "1.9.1";
  binary = "bandwidth";

  drv = pkgs.buildGoModule {
    pname = "cni-plugins-${binary}";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "containernetworking";
      repo = "plugins";
      rev = "v${version}";
      hash = "sha256-3OhUvIJPU5Ayc4/po9Rj4Tfa5536aN8bj+51M6Xg5os=";
    };

    vendorHash = null;  # upstream ships committed vendor/

    subPackages = [ "plugins/meta/${binary}" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "CNI bandwidth plugin";
      homepage = "https://github.com/containernetworking/plugins";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "cni-plugins-bandwidth";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/${binary}" ];
  cmd = [];
  labels = {
    "org.opencontainers.image.title" = "cni-plugins-bandwidth";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
