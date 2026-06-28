{ nix2container, lib, buildEnv, pkgs, base, nonRoot, ... }:

let
  packages = with pkgs; [
    minio
    bash
    coreutils
  ];

  userEnv = nonRoot.mkDefaultUserEnv pkgs [];

  # `minio server /data` needs /data to pre-exist writable by the nonroot user
  # (it can't create /data at / itself), plus a writable /tmp for multipart
  # staging. buildEnv otherwise leaves /tmp a read-only store symlink and never
  # creates /data, so the server fails to start.
  writableDirs = pkgs.runCommand "minio-writable-dirs" {} ''
    mkdir -p $out/data
    mkdir -p $out/tmp
    chmod 700 $out/data
  '';

in
nix2container.buildImage {
  name = "minio";
  # Version-tag the image (matches the org.opencontainers.image.version label).
  tag = pkgs.minio.version;

  # Separate layers so the writable-dirs scaffold can declare its own perms
  # without colliding with buildEnv's read-only /tmp symlink.
  layers = [
    (nix2container.buildLayer {
      copyToRoot = [
        (buildEnv {
          name = "minio-root";
          paths = base.basePackages ++ packages ++ [ userEnv ];
        })
      ];
    })
    (nix2container.buildLayer {
      copyToRoot = [ writableDirs ];
      perms = [
        {
          path = writableDirs;
          regex = "/data";
          mode = "0700";
          uid = 65532;
          gid = 65532;
        }
        {
          path = writableDirs;
          regex = "/tmp";
          mode = "1777";
        }
      ];
    })
  ];

  config = nonRoot.defaultConfig // {
    Env = base.defaultEnv ++ nonRoot.userEnv ++ [
      "PATH=${lib.makeBinPath packages}"
      "MINIO_ROOT_USER=minioadmin"
      "MINIO_ROOT_PASSWORD=minioadmin"
    ];
    ExposedPorts = {
      "9000/tcp" = {};
      "9001/tcp" = {};
    };
    Entrypoint = [ "${pkgs.minio}/bin/minio" ];
    Cmd = [ "server" "/data" "--console-address" ":9001" ];
    Labels = base.defaultLabels // {
      "io.nix-containers.build-type" = "source";
      "io.nix-containers.build-method" = "Built from source using Nix";
      "org.opencontainers.image.description" = "High Performance Object Storage";
      "org.opencontainers.image.version" = pkgs.minio.version;
      "io.nix-containers.chart" = "loki,tempo";
    };
  };
}
