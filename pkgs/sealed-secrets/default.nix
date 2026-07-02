{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/bitnami-labs/sealed-secrets

buildGoModule rec {
  pname = "sealed-secrets";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    hash = "sha256-a8D/k3Fxe/Im6tZqivvO9h/H4rVLZrHRli8xTHnDelI=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/controller"
    "cmd/kubeseal"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.VERSION=${version}"
  ];

  postInstall = ''
    mv $out/bin/controller $out/bin/sealed-secrets-controller
  '';

  doCheck = false;

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://sealed-secrets.netlify.app/";
    license = licenses.asl20;
  };
}
