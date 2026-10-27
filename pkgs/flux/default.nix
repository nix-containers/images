{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/fluxcd/flux2

buildGoModule rec {
  pname = "flux";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    hash = "sha256-BE8uDHDMaOOEFOb6UEIH8L5uzVKn/Eybf2fynLkD2Pc=";
  };

  vendorHash = "sha256-AgWDvlXVZXXprWCeoNeAMDb6LeYfa9yG5afc7TNISQs=";

  subPackages = [ "cmd/flux" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.VERSION=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Open and extensible continuous delivery solution for Kubernetes";
    homepage = "https://fluxcd.io/";
    license = licenses.asl20;
  };
}
