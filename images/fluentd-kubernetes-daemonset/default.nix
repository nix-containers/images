{ mkImage, pkgs, lib, ... }:

# fluentd-kubernetes-daemonset
# =============
# Fluentd (the log collector shipped by fluent/fluentd-kubernetes-daemonset).
# https://github.com/fluent/fluentd-kubernetes-daemonset  https://www.fluentd.org/
#
# Was a bare stub (bash/coreutils only, tag = "latest", no Cmd), so the
# kind-test pod failed with "no command specified". Completed by mirroring the
# sibling `fluentd` image. NOTE: the upstream daemonset image also bundles Ruby
# plugins (kubernetes_metadata_filter + an output plugin such as elasticsearch);
# those aren't packaged in nixpkgs, so this ships the Fluentd core with a
# working default config. Operators mount their own config + plugins.

let
  # Extract version from package name (fluentd-1.18.0 -> 1.18.0)
  version = builtins.elemAt (lib.splitString "-" pkgs.fluentd.name) 1;

  # The cmd points -c at /fluentd/etc/fluent.conf (the upstream image's config
  # path), but nothing baked that file — Fluentd exits ("config file not
  # found"). Bake a minimal config there using only core plugins: a `sample`
  # input feeding the `stdout` output, plus the `monitor_agent` HTTP endpoint on
  # 0.0.0.0:24220 (in-memory, no buffer files / writable dir). Operators mount
  # their own config with real k8s sources/filters/matches.
  fluentdConfig = pkgs.writeTextDir "fluentd/etc/fluent.conf" ''
    <source>
      @type sample
      tag sample
      sample {"message":"hello fluentd"}
    </source>

    <source>
      @type monitor_agent
      bind 0.0.0.0
      port 24220
    </source>

    <match **>
      @type stdout
    </match>
  '';
in
mkImage {
  drv = pkgs.fluentd;
  name = "fluentd-kubernetes-daemonset";
  tag = "v${version}";
  entrypoint = [ "${pkgs.fluentd}/bin/fluentd" ];
  cmd = [ "-c" "/fluentd/etc/fluent.conf" ];

  extraPkgs = [ fluentdConfig ];

  env = {
    FLUENTD_CONF = "fluent.conf";
    FLUENTD_OPT = "";
  };

  labels = {
    "org.opencontainers.image.title" = "fluentd-kubernetes-daemonset";
    "org.opencontainers.image.description" = "Fluentd log collector (Kubernetes daemonset distribution) - unified logging layer";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "fluentd";
  };
}
