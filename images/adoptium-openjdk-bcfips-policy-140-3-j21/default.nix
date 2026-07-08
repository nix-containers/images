{ nix2container, pkgs, lib, ... }:

# adoptium-openjdk-bcfips-policy-140-3-j21 — mirror of OSS upstream docker.io/eclipse-temurin (#618).
let
  upstream = nix2container.pullImage {
    imageName = "docker.io/eclipse-temurin";
    imageDigest = "sha256:1eeacc8c295ed4805f6ffead2417b1936aad296b02ea9e56b457230befc9e98d";
    sha256 = "sha256-7K0pLbY3SDh4TemJXkmpMeBo2H5gp3Z5AzmSxqwsoTs=";
  };
in
nix2container.buildImage {
  name = "adoptium-openjdk-bcfips-policy-140-3-j21";
  tag = "21";
  fromImage = upstream;
}
