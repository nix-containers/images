{ mkImage, pkgs, lib, ... }:

# keycloak-config-cli-nixchart
# ============================
# adorsys/keycloak-config-cli: declarative Keycloak realm/config seeder.
# Distributed as an uber-jar (Spring Boot) — we fetch the jar and run
# it on top of a JRE. The chart pairs this image with a keycloak image
# to bootstrap a realm.

let
  version = "6.5.1";
  # Uber-jar filename is keyed to target Keycloak minor.
  keycloakTarget = "26.1.0";

  cliJar = pkgs.fetchurl {
    url = "https://github.com/adorsys/keycloak-config-cli/releases/download/v${version}/keycloak-config-cli-${keycloakTarget}.jar";
    hash = "sha256-yTfOAl/5Ujyi7KvU7LEwmbma3azYqp4/8qwufiHWoyk=";
  };

  install = pkgs.runCommand "keycloak-config-cli-install" {} ''
    mkdir -p $out/opt/keycloak-config-cli
    cp ${cliJar} $out/opt/keycloak-config-cli/keycloak-config-cli.jar
  '';

in
mkImage {
  drv = pkgs.buildEnv {
    name = "keycloak-config-cli-nixchart-env";
    paths = [ install pkgs.jre pkgs.bash pkgs.coreutils pkgs.cacert ];
  };

  name = "keycloak-config-cli-nixchart";
  tag = "v${version}";

  entrypoint = [ "${pkgs.jre}/bin/java" ];
  cmd = [ "-jar" "/opt/keycloak-config-cli/keycloak-config-cli.jar" ];

  user = "1001:0";

  labels = {
    "org.opencontainers.image.title" = "keycloak-config-cli-nixchart";
    "org.opencontainers.image.description" = "adorsys/keycloak-config-cli declarative realm seeder";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "keycloak";
  };
}
