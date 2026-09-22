{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/vmware-tanzu/velero

buildGoModule rec {
  pname = "velero";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    rev = "v${version}";
    hash = "sha256-lvHbR+GaN6DeSv2UkIyR+aN3UWt3fYTCnvZyYhK+wzw=";
  };

  vendorHash = "sha256-yoTl5kmM4VKrLgvEUNaKYCiNbspd4VgG8CbulKjnoJE=";

  subPackages = [
    "cmd/velero"
    "cmd/velero-restore-helper"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Backup and migrate Kubernetes applications and their persistent volumes";
    homepage = "https://velero.io/";
    license = licenses.asl20;
  };
}
