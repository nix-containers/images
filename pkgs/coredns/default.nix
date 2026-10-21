{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/coredns/coredns

buildGoModule rec {
  pname = "coredns";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    hash = "sha256-/r0OBNg7VlsUZkojyGT1lwca3E1ZQZ5IroVwV8y4iME=";
  };

  vendorHash = "sha256-I+lO6HMtKX8N79Bdm8AzzIZe8mMYjHklZ85HjAjL1lk=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/coredns/coredns/coremain.GitCommit=v${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "CoreDNS is a DNS server that chains plugins";
    homepage = "https://coredns.io/";
    license = licenses.asl20;
  };
}
