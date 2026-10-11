{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner

buildGoModule rec {
  pname = "local-volume-provisioner";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "sig-storage-local-static-provisioner";
    rev = "v${version}";
    hash = "sha256-rQXVC4rrPLzSjWEn07553RCzn32Mhdr4TvMxjdwvYMM=";
  };

  vendorHash = null;

  subPackages = [ "cmd/local-volume-provisioner" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Static provisioner of local volumes";
    homepage = "https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner";
    license = licenses.asl20;
  };
}
