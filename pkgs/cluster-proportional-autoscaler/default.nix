{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-sigs/cluster-proportional-autoscaler

buildGoModule rec {
  pname = "cluster-proportional-autoscaler";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-proportional-autoscaler";
    rev = "v${version}";
    hash = "sha256-0uSAEor9yc2oF0xWdDK3vzByIbvdKBwu/vCy1ldvNYs=";
  };

  vendorHash = null;

  subPackages = [ "cmd/cluster-proportional-autoscaler" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X k8s.io/component-base/version.gitVersion=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Container autoscaler based on cluster size";
    homepage = "https://github.com/kubernetes-sigs/cluster-proportional-autoscaler";
    license = licenses.asl20;
  };
}
