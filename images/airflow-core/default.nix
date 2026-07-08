{ nix2container, pkgs, lib, ... }:

# airflow-core — mirror of OSS upstream docker.io/apache/airflow (#618).
let
  upstream = nix2container.pullImage {
    imageName = "docker.io/apache/airflow";
    imageDigest = "sha256:fb2c895e33395e4224c3de041e1751b095ee2c214cdf2d330bbaf62fcce0f54b";
    sha256 = "sha256-rCNA/cn9JfyMqKIUI1r0ugm/NgEtNCzpuZ6tg/WlohQ=";
  };
in
nix2container.buildImage {
  name = "airflow-core";
  tag = "3.3.0";
  fromImage = upstream;
}
