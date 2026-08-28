{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/argoproj/argo-rollouts

buildGoModule rec {
  pname = "argo-rollouts";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-rollouts";
    rev = "v${version}";
    hash = "sha256-DEpMNK/NDXykfYDWUCvLm+zoNaQ4YRGExznJoW3l5F0=";
  };

  vendorHash = "sha256-bF4jIEEG5DFhtDdy8LwK6SfE5OdyUsDjOIbAddvb5V8=";

  subPackages = [
    "cmd/rollouts-controller"
    "cmd/kubectl-argo-rollouts"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/argoproj/argo-rollouts/utils/version.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Progressive Delivery for Kubernetes";
    homepage = "https://argoproj.github.io/argo-rollouts/";
    license = licenses.asl20;
  };
}
