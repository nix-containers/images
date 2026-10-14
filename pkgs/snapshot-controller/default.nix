{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-csi/external-snapshotter

buildGoModule rec {
  pname = "snapshot-controller";
  version = "8.7.0";

  src = fetchFromGitHub {
    owner = "kubernetes-csi";
    repo = "external-snapshotter";
    rev = "v${version}";
    hash = "sha256-O3GLie9MDjr56L1xD1fdqo6E0C3hAx60KE39XLFgQwE=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/snapshot-controller"
    "cmd/csi-snapshotter"
    "cmd/snapshot-validation-webhook"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "CSI snapshot controller and sidecar";
    homepage = "https://github.com/kubernetes-csi/external-snapshotter";
    license = licenses.asl20;
  };
}
