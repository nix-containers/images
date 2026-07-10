{ mkImage, pkgs, lib, ... }:

# Open Policy Agent (OPA) - general-purpose policy engine
# https://github.com/open-policy-agent/opa
# -fips variant packages the upstream opa binary (no FIPS claim made).
#
# Built from source with current nixpkgs Go so Go-stdlib CVEs from the
# upstream prebuilt binary clear at each rebuild.

let
  version = "1.18.2";

  drv = pkgs.buildGoModule {
    pname = "opa-fips";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "open-policy-agent";
      repo = "opa";
      rev = "v${version}";
      hash = "sha256-z4zLeSVDULl2uYOURD8Cmq3qj7XJxXMd/jk5CaCrbUU=";
    };

    proxyVendor = true;
    vendorHash = "sha256-7HFxGKSzDB7LlvkccHVzgwIpp/fKuMrKJuDlVtrNvb0=";

    subPackages = [ "." ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    postInstall = ''
      if [ -e $out/bin/opa ]; then
        :
      elif [ -e $out/bin/open-policy-agent ]; then
        mv $out/bin/open-policy-agent $out/bin/opa
      fi
    '';
  };
in mkImage {
  inherit drv;
  name = "opa-fips";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/opa" ];
  # Was `--help` (a one-shot, so the kind-test pod CrashLoops). Run the policy
  # engine's REST API: `run --server`. OPA needs no config file, datastore or
  # writable dir to start (in-memory store; bundles load from read-only paths).
  # IMPORTANT: in OPA v1 (this is v1.18.1) `--addr` defaults to LOCALHOST only,
  # so the kind-test probe couldn't reach it — bind 0.0.0.0:8181 explicitly.
  # Same tool as the sibling `opa` image, whose kind-test validates this cmd.
  cmd = [ "run" "--server" "--addr" "0.0.0.0:8181" ];
  labels = {
    "org.opencontainers.image.title" = "opa-fips";
    "org.opencontainers.image.description" = "Open Policy Agent policy engine";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
