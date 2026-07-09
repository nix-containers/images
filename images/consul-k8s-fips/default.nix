{ mkImage, pkgs, lib, ... }:

# consul-k8s CLI - control plane for Consul on Kubernetes
# https://github.com/hashicorp/consul-k8s
# -fips variant packages the upstream binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. The CLI lives in cli/.

let
  version = "1.8.14";

  drv = pkgs.buildGoModule {
    pname = "consul-k8s-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "hashicorp";
      repo = "consul-k8s";
      rev = "v${version}";
      hash = "sha256-Yy/cWRdbhbQseb/D7T4y8bB01tZHC6umB+gyGLjUHiA=";
    };

    modRoot = "cli";
    proxyVendor = true;
    vendorHash = "sha256-ocTpSmkuW8L7U42FH6SDZbb2lR7q27wtwZn2L19UoiM=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/cli ]; then
        mv $out/bin/cli $out/bin/consul-k8s
      fi
    '';
  };

in mkImage {
  inherit drv;
  name = "consul-k8s-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/consul-k8s" ];
  cmd = [ "version" ];
  labels = {
    "org.opencontainers.image.title" = "consul-k8s-fips";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
