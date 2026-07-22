{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler

buildGoModule rec {
  pname = "cluster-autoscaler";
  version = "chart-9.59.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "autoscaler";
    rev = "cluster-autoscaler-${version}";
    hash = "sha256-yswbA5NDzXTiGkamljNySTe6aOZKWWhR8Hc9UJUhWRY=";
  };

  vendorHash = null;

  subPackages = [ "cluster-autoscaler" ];

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "Cluster Autoscaler automatically adjusts the size of a Kubernetes cluster";
    homepage = "https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler";
    license = licenses.asl20;
  };
}
