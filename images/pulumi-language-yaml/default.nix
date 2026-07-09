{ mkImage, pkgs, lib, ... }:

# pulumi-language-yaml - Pulumi YAML language host plugin
# https://github.com/pulumi/pulumi-yaml
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
let
  version = "1.37.0";

  drv = pkgs.buildGoModule {
    pname = "pulumi-language-yaml";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "pulumi";
      repo = "pulumi-yaml";
      rev = "v${version}";
      hash = "sha256-M81TporoBWcu6+yzLgZivKxOhiImYURlFWNo5f/5IF0=";
    };

    proxyVendor = true;
    vendorHash = "sha256-b6qZyCvk3jAJMk+1Zn/h0cTjaWN3knUFOlzTbPsuyiI=";

    subPackages = [ "cmd/pulumi-language-yaml" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;
  };
in mkImage {
  inherit drv;
  name = "pulumi-language-yaml";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/pulumi-language-yaml" ];
  cmd = [ "--help" ];
  labels = {
    "org.opencontainers.image.title" = "pulumi-language-yaml";
    "org.opencontainers.image.description" = "Pulumi YAML language host plugin";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
