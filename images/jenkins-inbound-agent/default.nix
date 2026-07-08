{ nix2container, lib, pkgs, ... }:

# jenkins-inbound-agent — UPSTREAM REFERENCE (not built or hosted by us).
# Use the OSS upstream image directly: docker.io/jenkins/inbound-agent:3383.vc8881d4b_0e76-1-jdk21
# Cataloged with a "Good Upstream" badge (interim). #618
nix2container.buildImage {
  name = "jenkins-inbound-agent";
  tag = "3383.vc8881d4b_0e76-1-jdk21";
  config.Labels = {
    "org.opencontainers.image.version" = "3383.vc8881d4b_0e76-1-jdk21";
    "org.opencontainers.image.description" = "Upstream reference — pull docker.io/jenkins/inbound-agent:3383.vc8881d4b_0e76-1-jdk21 directly.";
    "io.nix-containers.upstream-image" = "docker.io/jenkins/inbound-agent:3383.vc8881d4b_0e76-1-jdk21";
    "io.nix-containers.image.upstream" = "docker.io/jenkins/inbound-agent";
  };
}
