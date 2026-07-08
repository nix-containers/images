{ mkImage, fetchFromGitHub, buildGoModule, lib, ... }:

let
  version = "2.2.1";
  kubeflow-trainer = buildGoModule {
    pname = "kubeflow-training-operator";
    inherit version;

    src = fetchFromGitHub {
      owner = "kubeflow";
      repo = "training-operator";
      rev = "v${version}";
      hash = "sha256-lg1ttgGgj5PsxyR+pCKzbXTmWE5cdQQpWdUpDhSS/t4=";
    };

    proxyVendor = true;
    vendorHash = "sha256-68DI4D+oDonKVFaB/zXstS28085o1ZWzGxtls9S1eCU=";

    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";

    ldflags = [
      "-s" "-w"
      "-X main.version=${version}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "Kubeflow Training Operator for distributed ML training";
      homepage = "https://github.com/kubeflow/training-operator";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = kubeflow-trainer;
  name = "kubeflow-trainer";
  tag = "v${version}";
  entrypoint = [ "${kubeflow-trainer}/bin/training-operator" ];
  cmd = [];

  labels = {
    "org.opencontainers.image.title" = "Kubeflow Training Operator";
    "org.opencontainers.image.description" = "Distributed ML training on Kubernetes";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "kubeflow-trainer";
  };
}
