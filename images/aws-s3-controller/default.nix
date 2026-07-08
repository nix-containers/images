{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# aws-s3-controller
# AWS Kubernetes component

let
  version = "1.8.1";
  aws-component = buildGoModule {
    pname = "aws-s3-controller";
    inherit version;

    src = fetchFromGitHub {
      owner = "aws-controllers-k8s";
      repo = "s3-controller";
      rev = "v${version}";
      hash = "sha256-uEEI8wgqSsiYL1fCiX4qDr8O9oE5Hl2oN6fRg8QcrW0=";
    };

    proxyVendor = true;
    vendorHash = "sha256-U6fMbd+AOxu5CwBbFLvy23nU4h3KOHeAOz1rEe/T5wk=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = aws-component;
  name = "aws-s3-controller";
  tag = "v${version}";
  entrypoint = [ "${aws-component}/bin/s3-controller" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "aws s3 controller";
    "org.opencontainers.image.description" = "AWS aws-s3-controller component";
    "org.opencontainers.image.version" = version;
  };
}
