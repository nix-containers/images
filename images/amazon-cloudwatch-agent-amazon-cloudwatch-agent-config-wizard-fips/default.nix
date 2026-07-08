{ nix2container, pkgs, lib, ... }:

# amazon-cloudwatch-agent-amazon-cloudwatch-agent-config-wizard-fips — mirror of OSS upstream docker.io/amazon/cloudwatch-agent (#618).
let
  upstream = nix2container.pullImage {
    imageName = "docker.io/amazon/cloudwatch-agent";
    imageDigest = "sha256:4722a6621bc05c94a852513a8c463dc7a69e3f15b99702aa347e5f8a0d994e7f";
    sha256 = "sha256-tRT9tXcynXCMrOcmU4xUbBCV/LfwR1Q9+hIAAmPw03A=";
  };
in
nix2container.buildImage {
  name = "amazon-cloudwatch-agent-amazon-cloudwatch-agent-config-wizard-fips";
  tag = "1.300069.0b1529";
  fromImage = upstream;
}
