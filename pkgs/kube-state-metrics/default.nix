{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes/kube-state-metrics

buildGoModule rec {
  pname = "kube-state-metrics";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kube-state-metrics";
    rev = "v${version}";
    hash = "sha256-tgPbb7N/ZrIJqJF50kpJ5VOADSHnJ7dprxvL+J81Tjk=";
  };

  vendorHash = "sha256-vmmXEDzkv+ZQaKJ6++HpPHj2M9gaquonNjXG2DOlxwI=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X k8s.io/kube-state-metrics/v2/pkg/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Generate metrics from Kubernetes API objects";
    homepage = "https://github.com/kubernetes/kube-state-metrics";
    license = licenses.asl20;
  };
}
