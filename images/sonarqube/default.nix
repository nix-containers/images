# sonarqube
# =============
# SonarQube - Code quality and security analysis platform
# https://github.com/SonarSource/sonarqube
#
# SonarQube is a Java application for continuous code quality inspection.
# We download the official distribution and run it with Java from nixpkgs.

{ nix2container, pkgs, lib, fetchzip, ... }:

let
  # SonarQube Community Build — the 10.x line was EOL'd; the same product
  # is now shipped as SonarQube Community Build with date-based (25.x)
  # versions.
  version = "25.3.0.104237";
  majorVersion = builtins.head (lib.splitString "." version);

  # Download SonarQube distribution, then strip the bundled Elasticsearch
  # security-CLI tooling. SonarQube embeds Elasticsearch (still on the 7.17
  # line) for search; ES 7.17 is EOL and its bundled bcprov/bcpkix/bcutil
  # remain at 1.78.1, which triggers CVE-2025-14813 (critical). The tools
  # in `security-cli/` (elasticsearch-users, elasticsearch-service-tokens,
  # etc.) are admin utilities never executed at runtime by SonarQube (which
  # starts ES with security disabled and manages users itself), so removing
  # them clears the CVE with no functional impact.
  sonarqubeSrc = pkgs.fetchzip {
    url = "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${version}.zip";
    hash = "sha256-mP2+Mf+6VK5mcpdkxUnxgOWOBIShhrpEYmRlcShV1bE=";
  };
  sonarqube = pkgs.runCommand "sonarqube-${version}-stripped" {} ''
    mkdir -p $out
    cp -r ${sonarqubeSrc}/. $out/
    chmod -R u+w $out
    rm -rf $out/elasticsearch/lib/tools/security-cli
  '';

  # Wrapper script for SonarQube. Community Build 25.x requires Java 17+;
  # keep openjdk17 pinned so we don't accidentally jump to 21 without
  # verifying the SonarQube runtime supports it.
  sonarqubeWrapper = pkgs.writeShellScript "sonarqube-wrapper" ''
    #!/bin/bash
    set -e

    export SONAR_HOME=/opt/sonarqube
    export SONAR_JAVA_PATH=${pkgs.openjdk17}/bin/java

    # Ensure data directories exist
    mkdir -p /opt/sonarqube/data
    mkdir -p /opt/sonarqube/logs
    mkdir -p /opt/sonarqube/temp
    mkdir -p /opt/sonarqube/extensions

    # Start SonarQube
    exec ${pkgs.openjdk17}/bin/java \
      -server \
      -Xms512m -Xmx512m \
      -XX:+HeapDumpOnOutOfMemoryError \
      -Djava.net.preferIPv4Stack=true \
      -Dsonar.path.home=/opt/sonarqube \
      -Dsonar.path.data=/opt/sonarqube/data \
      -Dsonar.path.logs=/opt/sonarqube/logs \
      -Dsonar.path.temp=/opt/sonarqube/temp \
      -jar /opt/sonarqube/lib/sonarqube.jar \
      "$@"
  '';

in
nix2container.buildImage {
  name = "sonarqube";
  tag = "v${version}";

  copyToRoot = pkgs.buildEnv {
    name = "sonarqube-root";
    paths = [
      # Java runtime
      pkgs.openjdk17

      # Shell and utilities
      pkgs.bash
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.procps
      pkgs.curl
      pkgs.wget

      # SSL/TLS
      pkgs.cacert

      # Create directories and copy SonarQube
      (pkgs.runCommand "sonarqube-install" {} ''
        mkdir -p $out/opt/sonarqube
        cp -r ${sonarqube}/* $out/opt/sonarqube/
        chmod -R u+w $out/opt/sonarqube

        mkdir -p $out/opt/sonarqube/data
        mkdir -p $out/opt/sonarqube/logs
        mkdir -p $out/opt/sonarqube/temp
        mkdir -p $out/opt/sonarqube/extensions/plugins

        mkdir -p $out/bin
        cp ${sonarqubeWrapper} $out/bin/sonarqube
        chmod +x $out/bin/sonarqube

        mkdir -p $out/tmp
      '')
    ];
    pathsToLink = [ "/bin" "/etc" "/lib" "/share" "/opt" "/tmp" ];
  };

  config = {
    entrypoint = [ "/opt/sonarqube/bin/linux-x86-64/sonar.sh" ];
    cmd = [ "console" ];
    workingDir = "/opt/sonarqube";
    exposedPorts = {
      "9000/tcp" = {};
    };
    env = [
      "JAVA_HOME=${pkgs.openjdk17}"
      "SONAR_HOME=/opt/sonarqube"
      "SONARQUBE_HOME=/opt/sonarqube"
    ];
    labels = {
      "org.opencontainers.image.title" = "SonarQube";
      "org.opencontainers.image.description" = "Code quality and security analysis platform";
      "org.opencontainers.image.version" = version;
      "io.nix-containers.chart" = "sonarqube";
    };
  };
}
