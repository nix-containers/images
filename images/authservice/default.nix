# authservice
# =============
# Istio Authservice - OIDC authentication for Istio/Envoy
# https://github.com/istio-ecosystem/authservice

{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# Authservice implements Envoy External Authorization for OIDC authentication

let
  version = "1.1.7";
  authservice = buildGoModule {
    pname = "authservice";
    inherit version;

    src = fetchFromGitHub {
      owner = "istio-ecosystem";
      repo = "authservice";
      rev = "v${version}";
      hash = "sha256-rXXNUShJSF2xRzr8dGOHJGMzX5JL2ApxvTV79VAowaI=";
    };

    vendorHash = "sha256-89Yg585HVUn+QOZV8tnHSPStLjTZnrFiLQHfiyOesfU=";

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