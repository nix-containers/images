{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-csi/livenessprobe

buildGoModule rec {
  pname = "livenessprobe";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "kubernetes-csi";
    repo = "livenessprobe";
    rev = "v${version}";
    hash = "sha256-yG7mt0ecUCagLTfu1lM3frtYzgTWeHQJHF/MB4sE7zU=";
  };

  vendorHash = null;

  subPackages = [ "cmd/livenessprobe" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A sidecar container that can be included in CSI driver pods to enable liveness probe";
    homepage = "https://github.com/kubernetes-csi/livenessprobe";
    license = licenses.asl20;
  };
}
