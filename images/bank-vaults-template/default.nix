{ mkImage, pkgs, lib, ... }:

# template - config templating helper shipped in the bank-vaults release
# https://github.com/bank-vaults/bank-vaults
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.33.1";

  drv = pkgs.buildGoModule {
    pname = "bank-vaults-template";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "bank-vaults";
      repo = "bank-vaults";
      rev = "v${version}";
      hash = "sha256-D0rgrYQDIYU6BwSOgmDLbetDsyCT6Dvlw0UminH4hfo=";
    };

    proxyVendor = true;
    vendorHash = "sha256-WgsaZoTmBkIq7YbX3B3WMwd5+lhMIOUM4N8cYPj2hqA=";

    subPackages = [ "cmd/template" ];
    ldflags = [ "-s" "-w" ];
    # cmd/template pulls in the same bank-vaults module tree which uses
    # miekg/pkcs11/p11 transitively; leave cgo on to be safe.
    env.CGO_ENABLED = 1;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "bank-vaults-template";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/template" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "bank-vaults-template";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
