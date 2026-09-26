{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-csi/external-resizer

buildGoModule rec {
  pname = "csi-resizer";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "kubernetes-csi";
    repo = "external-resizer";
    rev = "v${version}";
    hash = "sha256-DyxlmJ/YFPCEreS9chjkV/dQFOEBgLv1ec00QV2hWls=";
  };

  vendorHash = null;

  subPackages = [ "cmd/csi-resizer" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Sidecar container that watches Kubernetes PVC objects and triggers ControllerExpandVolume against CSI endpoint";
    homepage = "https://github.com/kubernetes-csi/external-resizer";
    license = licenses.asl20;
  };
}
