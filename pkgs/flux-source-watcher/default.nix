{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/fluxcd/source-watcher

buildGoModule rec {
  pname = "flux-source-watcher";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "source-watcher";
    rev = "v${version}";
    hash = "sha256-B4U8HpKkNIOhI0zZoB+i2Y/r1Oss2n7Z9rrX1d510k4=";
  };

  vendorHash = "sha256-XdhUgd4Z0RX+HqWGdRBNeXsAprNkbDEqtoldwZ+YZp8=";

  subPackages = [ "cmd" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/cmd $out/bin/source-watcher
  '';

  meta = with lib; {
    description = "Flux source watcher - example controller for watching GitRepository and Bucket sources";
    homepage = "https://github.com/fluxcd/source-watcher";
    license = licenses.asl20;
  };
}
