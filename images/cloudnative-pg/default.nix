{ mkImage, pkgs, lib, ... }:

# Uses cloudnative-pg package from pkgs/cloudnative-pg
# Built from wolfi-dev/os cloudnative-pg.yaml
# https://github.com/cloudnative-pg/cloudnative-pg

let
  cloudnative-pg = pkgs.cloudnative-pg;
  version = cloudnative-pg.version;
  goArch = pkgs.stdenv.hostPlatform.go.GOARCH;

  # The cloudnative-pg helm chart hardcodes the operator container's
  # command as `["/manager"]` (see chart's Deployment template), so any
  # drop-in replacement image MUST expose `/manager` at the rootfs top
  # level. nixpkgs puts the binary at /nix/store/.../bin/manager, so we
  # inject a symlink. Same pattern as the keda chart's `/keda` symlink
  # added in PR #39 (chart-cmd-paths assertion in smoketest-helpers.sh).
  # The operator discovers injectable instance-manager binaries by globbing
  # `operator/manager_<goarch>` relative to its working directory (`/`).
  managerCompat = pkgs.runCommand "cloudnative-pg-manager-compat" {} ''
    mkdir -p $out/operator
    ln -s ${cloudnative-pg}/bin/manager $out/manager
    ln -s ${cloudnative-pg}/bin/manager_${goArch} $out/operator/manager_${goArch}
  '';
in
mkImage {
  drv = cloudnative-pg;
  name = "cloudnative-pg";
  tag = "v${version}";
  entrypoint = [ "${cloudnative-pg}/bin/manager" ];
  cmd = [];

  extraContents = [ managerCompat ];

  labels = {
    "org.opencontainers.image.title" = "CloudNativePG Operator";
    "org.opencontainers.image.description" = "PostgreSQL operator for Kubernetes";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "cloudnative-pg";
  };
}
