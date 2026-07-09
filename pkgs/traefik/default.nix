{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/traefik/traefik

buildGoModule rec {
  pname = "traefik";
  version = "3.7.7";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "traefik";
    rev = "v${version}";
    hash = "sha256-eFTWVpW0oWztUiluQf1dbbX81hEMWiLogR8GbkNTaw0=";
  };

  vendorHash = "sha256-zIj943rlUWoYdBgmgdYaw6dBPZBEZtlBDs4p1rurpLc=";

  subPackages = [ "cmd/traefik" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/traefik/traefik/v3/pkg/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "The Cloud Native Application Proxy";
    homepage = "https://traefik.io/";
    license = licenses.mit;
  };
}
