{ mkImage, pkgs, lib, ... }:

# Apache Flink - Stream processing framework
# https://flink.apache.org/
#
# Was cmd=["--help"] on the `flink` CLI (a one-shot -> the kind-test pod
# CrashLoops). Run a standalone-session JobManager in the foreground instead:
# it binds the REST/web UI on 0.0.0.0:8081 and stays up (operators run
# TaskManagers separately). nixpkgs.flink ships the full dist under
# opt/flink/, so use its jobmanager.sh.

let
  jdk = pkgs.jdk17_headless;

  # Run the JobManager in the foreground with headless overrides: REST/web UI on
  # 0.0.0.0:8081, RPC on localhost, tmp + logs + pid under the writable /tmp
  # mkImage provides (FLINK_HOME is a read-only nix store path). A modest process
  # size keeps the JVM within the CI runner.
  entrypoint = pkgs.writeShellApplication {
    name = "docker-entrypoint.sh";
    runtimeInputs = [ jdk pkgs.coreutils pkgs.bash ];
    text = ''
      export JAVA_HOME=${jdk}
      export FLINK_LOG_DIR=/tmp/flink-log
      export FLINK_PID_DIR=/tmp
      mkdir -p /tmp/flink-log /tmp/flink-tmp
      exec ${pkgs.flink}/opt/flink/bin/jobmanager.sh start-foreground \
        -D rest.bind-address=0.0.0.0 \
        -D jobmanager.rpc.address=localhost \
        -D jobmanager.bind-host=0.0.0.0 \
        -D io.tmp.dirs=/tmp/flink-tmp \
        -D jobmanager.memory.process.size=1000m \
        "$@"
    '';
  };
in
mkImage {
  drv = pkgs.flink;
  name = "flink";
  tag = "v${pkgs.flink.version}";
  entrypoint = [ "${entrypoint}/bin/docker-entrypoint.sh" ];
  cmd = [ ];

  labels = {
    "org.opencontainers.image.title" = "Apache Flink";
    "org.opencontainers.image.description" = "Distributed stream processing framework";
    "org.opencontainers.image.version" = pkgs.flink.version;
  };
}
