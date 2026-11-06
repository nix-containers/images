{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# aws-application-networking-k8s
# AWS Kubernetes component

let
  version = "2.1.4";
  aws-component = buildGoModule {
    pname = "aws-application-networking-k8s";
    inherit version;

    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-application-networking-k8s";
      rev = "v${version}";
      hash = "sha256-A1C4MZkOGS8kTiGr02eOcSiT7OZ7TgEnPw7bsBba86g=";
    };

    vendorHash = "sha256-cqW/kPhZFbmwQo63EOYZxcCuYOXMcGRUJF1sl5Uz/is=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = aws-component;
  name = "aws-application-networking-k8s";
  tag = "v${version}";
  entrypoint = [ "${aws-component}/bin/application-networking-k8s" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "aws application networking k8s";
    "org.opencontainers.image.description" = "AWS aws-application-networking-k8s component";
    "org.opencontainers.image.version" = version;
  };
}
