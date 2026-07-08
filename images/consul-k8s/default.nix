{ mkImage, pkgs, lib, ... }:

# Consul on Kubernetes control plane (consul-k8s-control-plane)
# https://github.com/hashicorp/consul-k8s
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.
#
# The repo is a Go monorepo; the control-plane module lives at
# control-plane/ with its own go.mod.

let
  version = "2.0.1";

  consul-k8s = pkgs.buildGoModule {
    pname = "consul-k8s-control-plane";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "hashicorp";
      repo = "consul-k8s";
      rev = "v${version}";
      hash = "sha256-jiFPpQgiUCNJ5B1dpnZpNVXqJq5DIrYzFg7ocNzLXeo=";
    };

    modRoot = "control-plane";
    proxyVendor = true;
    vendorHash = "sha256-fWv9/BLVcHrNXe6Qm9jsU14t/IQtUGzntgkzv8jZwPI=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/control-plane ]; then
        mv $out/bin/control-plane $out/bin/consul-k8s-control-plane
      fi
    '';

    meta = with lib; {
      description = "Consul on Kubernetes control plane";
      homepage = "https://github.com/hashicorp/consul-k8s";
      license = licenses.mpl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  drv = consul-k8s;
  name = "consul-k8s";
  tag = "v${version}";
  entrypoint = [ "${consul-k8s}/bin/consul-k8s-control-plane" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "consul-k8s";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
