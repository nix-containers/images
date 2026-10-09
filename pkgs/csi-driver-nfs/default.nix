{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-csi/csi-driver-nfs

buildGoModule rec {
  pname = "csi-driver-nfs";
  version = "4.13.5";

  src = fetchFromGitHub {
    owner = "kubernetes-csi";
    repo = "csi-driver-nfs";
    rev = "v${version}";
    hash = "sha256-At1O0iOD3UfvuFAargS0vsjl868Dw1ix4404RLwHE7k=";
  };

  vendorHash = null;

  subPackages = [ "cmd/nfsplugin" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/kubernetes-csi/csi-driver-nfs/pkg/nfs.driverVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/nfsplugin $out/bin/nfscsi
  '';

  doCheck = false;

  meta = with lib; {
    description = "CSI driver for Kubernetes NFS support";
    homepage = "https://github.com/kubernetes-csi/csi-driver-nfs";
    license = licenses.asl20;
  };
}
