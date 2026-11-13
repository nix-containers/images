# authservice
# =============
# Istio Authservice - OIDC authentication for Istio/Envoy
# https://github.com/istio-ecosystem/authservice

{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Authservice implements Envoy External Authorization for OIDC authentication

let
  version = "1.1.8";
  authservice = buildGoModule {
    pname = "authservice";
    inherit version;

    src = fetchFromGitHub {
      owner = "istio-ecosystem";
      repo = "authservice";
      rev = "v${version}";
      hash = "sha256-nlTBoXqkkkyzIBD/+eqkHKelZ0IE76RS1JK3kXlnVsI=";
    };

    vendorHash = "sha256-AG9v3aL9pC7rjHcoilklUpjBSGdhSJkRbx4Nau6RgCU=";

    subPackages = [ "cmd" ];

    env.CGO_ENABLED = 0;

    ldflags = [
      "-s" "-w"
      "-X main.version=${version}"
    ];

    doCheck = false;

    # Go names the output binary after the directory (`cmd`); rename to
    # match the expected image entrypoint.
    postInstall = ''
      mv $out/bin/cmd $out/bin/authservice
    '';

    meta = with lib; {
      description = "Istio Authservice - OIDC authentication for Istio/Envoy";
      homepage = "https://github.com/istio-ecosystem/authservice";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = authservice;
  name = "authservice";
  tag = "v${version}";
  entrypoint = [ "${authservice}/bin/authservice" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert ];

  labels = {
    "org.opencontainers.image.title" = "Authservice";
    "org.opencontainers.image.description" = "OIDC authentication service for Istio/Envoy";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "authservice";
  };
}