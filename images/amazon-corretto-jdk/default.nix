{ nix2container, pkgs, lib, ... }:

# amazon-corretto-jdk — mirror of OSS upstream docker.io/amazoncorretto (#618).
let
  upstream = nix2container.pullImage {
    imageName = "docker.io/amazoncorretto";
    imageDigest = "sha256:975b191f99b2f0fb9e76397b7d85523e9904dcb679e54d5f9099c1cdeab21cf1";
    sha256 = "sha256-A9KmYVQHiNH6noFek5VwEtpQZoJhiJhTf9lROGtyrLM=";
  };
in
nix2container.buildImage {
  name = "amazon-corretto-jdk";
  tag = "21";
  fromImage = upstream;
}
