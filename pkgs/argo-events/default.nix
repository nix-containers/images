{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/argoproj/argo-events

let
  goModBump = import ../../lib/goModBump.nix { inherit lib; };
in
buildGoModule (rec {
  pname = "argo-events";
  version = "1.9.11";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-events";
    rev = "v${version}";
    hash = "sha256-nj/5h5oQEKXbWJLeCzVD0CGQT9vpr/YNgN0nboarFqU=";
  };

  vendorHash = "sha256-VfRGYGcVMzYVbFlL32cbflOOiVH8ghoyJ8fLiPKkvks=";

  subPackages = [ "cmd" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/argoproj/argo-events.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/argo-events
  '';

  doCheck = false;

  meta = with lib; {
    description = "Event-driven workflow automation framework for Kubernetes";
    homepage = "https://argoproj.github.io/argo-events/";
    license = licenses.asl20;
  };
} // goModBump [
  "github.com/rabbitmq/amqp091-go@v1.13.0"
  "github.com/andybalholm/brotli@v1.2.7"
  "golang.org/x/net@v0.62.0"
  "golang.org/x/crypto@v0.58.0"
  "google.golang.org/grpc@v1.83.2"
  "github.com/go-git/go-git/v5@v5.19.2"
  "github.com/klauspost/compress@v1.20.2"
])
