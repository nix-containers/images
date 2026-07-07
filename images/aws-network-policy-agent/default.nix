{ mkImage, fetchFromGitHub, buildGoModule, pkgs, lib, ... }:

# aws-network-policy-agent
# AWS Kubernetes component

let
  version = "1.3.7";
  aws-component = buildGoModule {
    pname = "aws-network-policy-agent";
    inherit version;

    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-network-policy-agent";
      rev = "v${version}";
      hash = "sha256-KTVV8MJrT7MoyCr11oQuVxJkVaKBv7SGSV7pK6FMbC4=";
    };

    proxyVendor = true;
    vendorHash = "sha256-9oJIlJN+ylCoHLr5tlIWYxd5luWKiDCdOJau8CvDzag=";
    subPackages = [ "." ];
    
    env.CGO_ENABLED = 0;

    ldflags = [ "-s" "-w" ];
    doCheck = false;
  };

in
mkImage {
  drv = aws-component;
  name = "aws-network-policy-agent";
  tag = "v${version}";
  entrypoint = [ "${aws-component}/bin/network-policy-agent" ];
  cmd = [];

  extraPkgs = with pkgs; [ cacert tzdata ];

  labels = {
    "org.opencontainers.image.title" = "aws network policy agent";
    "org.opencontainers.image.description" = "AWS aws-network-policy-agent component";
    "org.opencontainers.image.version" = version;
  };
}
