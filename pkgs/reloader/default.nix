{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/stakater/Reloader

buildGoModule rec {
  pname = "reloader";
  version = "merge-1218";

  src = fetchFromGitHub {
    owner = "stakater";
    repo = "Reloader";
    rev = "v${version}";
    hash = "sha256-VfeIVFb6bCizkVhdCKdqKLKSW3tx5MgDwtFmwzrJ1ro=";
  };

  vendorHash = null;

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "Controller to watch changes in ConfigMap and Secrets to trigger rolling upgrade on Pods";
    homepage = "https://github.com/stakater/Reloader";
    license = licenses.asl20;
  };
}
