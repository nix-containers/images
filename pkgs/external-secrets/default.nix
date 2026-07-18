{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/external-secrets/external-secrets

buildGoModule rec {
  pname = "external-secrets";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "external-secrets";
    repo = "external-secrets";
    rev = "v${version}";
    hash = "sha256-K5S3Mmzt4Yt0+zZDCVKqQoBb6tVOSSb5UQiSPyMHYlA=";
  };

  vendorHash = "sha256-6Gdii+/UhOkaWwJRNZEtKXXDmodcBz1l8wjawAEToKY=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/external-secrets/external-secrets/pkg/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "External Secrets Operator reads from external APIs and injects values into Kubernetes Secrets";
    homepage = "https://external-secrets.io/";
    license = licenses.asl20;
  };
}
