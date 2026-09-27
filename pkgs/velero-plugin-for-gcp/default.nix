{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/vmware-tanzu/velero-plugin-for-gcp

buildGoModule rec {
  pname = "velero-plugin-for-gcp";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero-plugin-for-gcp";
    rev = "v${version}";
    hash = "sha256-pPMMq6O/A9FJVd2lyAKzC4pkHW3q9I+LQPzfDUk1XaI=";
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
