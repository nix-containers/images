{ mkImage, fetchFromGitHub, buildGoModule, lib, ... }:

let
  version = "2.5.1";
  spark-operator = buildGoModule {
    pname = "spark-operator";
    inherit version;

    src = fetchFromGitHub {
      owner = "kubeflow";
      repo = "spark-operator";
      rev = "v${version}";
      hash = "sha256-aDqzN98vEEQXnlPHGF2hKBssU5ls7YhmgHPt1Qa7g5A=";
    };

    proxyVendor = true;
    vendorHash = "sha256-pZhxVUhQiiX8/bMlso6pVj9WoIxLtPrwiMSPdoHaCAU=";

    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";

    ldflags = [
      "-s" "-w"
      "-X main.version=${version}"
    ];

    subPackages = [ "cmd/operator" ];

    postInstall = ''
      mv $out/bin/operator $out/bin/spark-operator
    '';

    doCheck = false;

    meta = with lib; {
      description = "Kubernetes operator for managing Apache Spark applications";
      homepage = "https://github.com/kubeflow/spark-operator";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = spark-operator;
  name = "spark-operator";
  tag = "v${version}";
  entrypoint = [ "${spark-operator}/bin/spark-operator" ];
  cmd = [];

  labels = {
    "org.opencontainers.image.title" = "Spark Operator";
    "org.opencontainers.image.description" = "Kubernetes operator for Apache Spark";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "spark-operator";
  };
}
