{ mkImage, pkgs, lib, ... }:

# OpenSearch - Search and analytics engine
# https://opensearch.org/

let
  opensearchPackages = with pkgs; [
    opensearch
    openjdk21_headless # OpenSearch 3.x runs on JDK 21; the nix package ships no bundled JRE
    bash
    coreutils
    gnused
    curl
    cacert
  ];

  # docker-entrypoint: seed a writable config dir from the read-only store
  # defaults, overlay a single-node / security-disabled opensearch.yml, then
  # exec the server. Without this the image had no Cmd and can't start (and the
  # read-only config/data/logs paths would fatal it). writeShellApplication runs
  # shellcheck at build time.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = opensearchPackages;
    text = builtins.readFile ./docker-entrypoint.sh;
  };
in
mkImage {
  drv = pkgs.opensearch;
  name = "opensearch";
  tag = "v${pkgs.opensearch.version}";
  # Was `cmd = []` on the bare opensearch launcher, which fatals on the
  # read-only config/data/logs. Run through the entrypoint above; the HTTP API
  # binds 0.0.0.0:9200.
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ "opensearch" ];

  extraPkgs = opensearchPackages;

  env = {
    OPENSEARCH_HOME = "${pkgs.opensearch}";
    OPENSEARCH_JAVA_HOME = "${pkgs.openjdk21_headless}";
    # Keep the JVM small so it fits the CI runner; the single-node start only
    # needs to launch and stay up, not serve a workload.
    OPENSEARCH_JAVA_OPTS = "-Xms512m -Xmx512m";
    HOME = "/tmp";
  };

  labels = {
    "org.opencontainers.image.title" = "OpenSearch";
    "org.opencontainers.image.description" = "Open source search and analytics suite";
    "org.opencontainers.image.version" = pkgs.opensearch.version;
  };
}
