{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/stakater/Reloader

buildGoModule rec {
  pname = "reloader";
  version = "1.4.21";

  src = fetchFromGitHub {
    owner = "stakater";
    repo = "Reloader";
    rev = "v${version}";
    hash = "sha256-jvPqv7gOBQm5g/OjfhhhVYI6aqyoEmb1nndAzRpmtnA=";
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
