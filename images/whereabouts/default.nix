{ mkImage, pkgs, lib, ... }:

# whereabouts — IPAM CNI plugin for Kubernetes multus setups
# https://github.com/k8snetworkplumbingwg/whereabouts
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild. Also bumps 0.6.1 → 0.9.4
# (latest release); the 0.6.1 line vendored a large stale x/net + x/crypto
# tree responsible for the 8-critical / 60-high CVE count.
let
  version = "0.9.4";

  drv = pkgs.buildGoModule {
    pname = "whereabouts";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "k8snetworkplumbingwg";
      repo = "whereabouts";
      rev = "v${version}";
      hash = "sha256-Sb3Wr1HYxfnvoIwNqMW8gaDJE+8j9f8GANcBHne8W0Q=";
    };

    # Upstream's vendor/modules.txt is out of sync with go.mod — refetch
    # via the module proxy instead of trusting the in-tree vendor.
    proxyVendor = true;
    vendorHash = "sha256-tkjizI9j9BcxDUsfu457Q5DnHkLABxbGlvBc2eNIpCs=";

    subPackages = [ "cmd" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    # cmd/ builds as `cmd` since main.go is at cmd/whereabouts.go with
    # `package main`. Rename to `whereabouts` to match the entrypoint.
    postInstall = ''
      if [ -e $out/bin/cmd ]; then
        mv $out/bin/cmd $out/bin/whereabouts
      fi
    '';
  };
in
mkImage {
  inherit drv;
  name = "whereabouts";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/whereabouts" ];
  cmd = [];
  extraPkgs = with pkgs; [ cacert tzdata ];
  labels = {
    "org.opencontainers.image.version" = version;
    "org.opencontainers.image.description" = "whereabouts IPAM CNI plugin (built from source)";
    "io.nix-containers.source" = "upstream-source";
  };
}
