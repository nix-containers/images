{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/vmware-tanzu/velero-plugin-for-gcp

buildGoModule rec {
  pname = "velero-plugin-for-gcp";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero-plugin-for-gcp";
    rev = "v${version}";
    hash = "sha256-j1rTl/K3E0rAGgZWVe3C/vOzIR0Hq7ofKeVY2Rjb5oQ=";
  };

  vendorHash = "sha256-hM7ddZaFQBOFKM1gqpNoHxx4hoJNmGtf5EdcFXOe7L8=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Plugins to support Velero on Google Cloud Platform (GCP)";
    homepage = "https://github.com/vmware-tanzu/velero-plugin-for-gcp";
    license = licenses.asl20;
  };
}
