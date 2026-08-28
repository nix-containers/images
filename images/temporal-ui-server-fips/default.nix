{ nix2container, lib, buildEnv, pkgs, base, nonRoot, ... }:

# temporal-ui-server-fips
# Container image

let
  version = "2.52.0";
  
  imagePkgs = with pkgs; [
    bash
    coreutils
    cacert
    tzdata
    temporal-ui-server
  ];

  userEnv = nonRoot.mkDefaultUserEnv pkgs [];

in nix2container.buildImage {
  name = "temporal-ui-server-fips";
  tag = version;
  copyToRoot = [
    (buildEnv {
      name = "temporal-ui-server-fips-root";
      paths = base.basePackages ++ imagePkgs ++ [ userEnv ];
    })
  ];
  config = nonRoot.defaultConfig // {
    Env = base.defaultEnv ++ nonRoot.userEnv;
    Labels = base.defaultLabels // {
      "io.nix-containers.build-type" = "source";
      "io.nix-containers.build-method" = "Built from source using Nix";
      "org.opencontainers.image.title" = "temporal ui server fips";
      "org.opencontainers.image.description" = "temporal-ui-server-fips container image";
      "org.opencontainers.image.version" = version;
    # No compliance label here: this image has no FIPS crypto backend.
    # The -fips images that genuinely qualify set
    # env.GOEXPERIMENT = "boringcrypto" (with CGO_ENABLED = 1) so the
    # binary links BoringCrypto; see age-fips for the reference shape.
    # Re-add this label only alongside such a build.
    };
  };
}
