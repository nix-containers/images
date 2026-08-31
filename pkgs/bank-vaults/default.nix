{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/bank-vaults/bank-vaults

buildGoModule rec {
  pname = "bank-vaults";
  version = "1.33.2";

  src = fetchFromGitHub {
    owner = "bank-vaults";
    repo = "bank-vaults";
    rev = "v${version}";
    hash = "sha256-e/6RhNnf1SQM4MJOi/ir7jAs6fFBkCnUO8NH7ZGIiTM=";
  };

  vendorHash = null;

  subPackages = [ "cmd/bank-vaults" "cmd/vault-env" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Vault swiss-army knife for managing secrets in Kubernetes";
    homepage = "https://github.com/bank-vaults/bank-vaults";
    license = licenses.asl20;
  };
}
