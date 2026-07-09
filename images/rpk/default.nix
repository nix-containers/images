{ mkImage, pkgs, lib, ... }:

# rpk - Redpanda CLI (Redpanda Keeper)
# https://github.com/redpanda-data/redpanda
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. The rpk Go module lives
# under src/go/rpk/ in the redpanda monorepo.

let
  version = "26.1.12";

  drv = pkgs.buildGoModule {
    pname = "rpk";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "redpanda-data";
      repo = "redpanda";
      rev = "v${version}";
      hash = "sha256-ZF9YzRW1b40syRCV+a5NOsS/SDwstVs1mI++dTDcpWc=";
    };

    modRoot = "src/go/rpk";
    proxyVendor = true;
    vendorHash = "sha256-PYEWP/9LYUrtmbmCsRrrRjwwRplrj3+3Udr6Ys5dTko=";

    subPackages = [ "cmd/rpk" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    meta = with lib; {
      description = "Redpanda CLI (rpk)";
      homepage = "https://github.com/redpanda-data/redpanda";
      license = licenses.bsl11;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "rpk";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/rpk" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "rpk";
    "org.opencontainers.image.description" = "Redpanda CLI";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
