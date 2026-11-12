{ nix2container, lib, buildEnv, pkgs, base, ... }:

let
  procps = pkgs.procps.override { withSystemd = false; };

  shellPackages = [ pkgs.bash pkgs.coreutils procps ];

  version = pkgs.bash.version;
in
nix2container.buildImage {
  name = "os-shell";
  tag = version;

  copyToRoot = [
    (buildEnv {
      name = "os-shell-root";
      paths = base.basePackages ++ shellPackages;
      pathsToLink = [ "/bin" "/etc" ];
    })
  ];

  config = {
    Cmd = [ "/bin/bash" ];
    User = "1001";
    Env = base.defaultEnv ++ [ "PATH=/bin" ];
    Labels = base.defaultLabels // {
      "io.nix-containers.build-type" = "source";
      "io.nix-containers.build-method" = "Built from source using Nix";
      "org.opencontainers.image.title" = "os-shell";
      "org.opencontainers.image.description" = "Minimal /bin/bash + coreutils + procps (sysctl) for chart init containers; replaces bitnami/os-shell";
      "org.opencontainers.image.url" = "https://github.com/nix-containers/images";
      "org.opencontainers.image.vendor" = "nix-containers";
      "org.opencontainers.image.version" = version;
      "io.nix-containers.image.upstream" = "https://www.gnu.org/software/bash/";
      "io.nix-containers.image.category" = "shell";
      "io.nix-containers.image.aliases" = "os-shell,bitnami/os-shell";
    };
  };
}
