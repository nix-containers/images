{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-sigs/aws-efs-csi-driver

buildGoModule rec {
  pname = "aws-efs-csi-driver";
  version = "helm-chart-aws-efs-csi-driver-4.4.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "aws-efs-csi-driver";
    rev = "v${version}";
    hash = "sha256-YmKaC7usnAi+zMENCc8CaqY/pwtFnVtNtUd/xdKIYeg=";
  };

  vendorHash = null;

  subPackages = [ "cmd" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/kubernetes-sigs/aws-efs-csi-driver/pkg/driver.driverVersion=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/aws-efs-csi-driver
  '';

  doCheck = false;

  meta = with lib; {
    description = "CSI driver for Amazon EFS";
    homepage = "https://github.com/kubernetes-sigs/aws-efs-csi-driver";
    license = licenses.asl20;
  };
}
