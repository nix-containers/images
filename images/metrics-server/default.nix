{ mkImage, buildGoModule, fetchFromGitHub, lib, ... }:


# Chainguard SBOM packages for metrics-server:
# Packages NOT in nixpkgs:
#   metrics-server (0.8.0-r5)

let
  version = "0.8.1";
  metrics-server = buildGoModule {
    pname = "metrics-server";
    inherit version;

    src = fetchFromGitHub {
      owner = "kubernetes-sigs";
      repo = "metrics-server";
      rev = "v${version}";
      hash = "sha256-ERrHDcacsPAL/44Ff3EWMaTvSv2c3o61uJeod1nduKc=";
    };

    proxyVendor = true;
    vendorHash = "sha256-OTrNmTHd2tSbUza+7fs+t0GNuIdpsCFl1AmW9DjaYo4=";

    subPackages = [ "cmd/metrics-server" ];

    env.CGO_ENABLED = 0;
    preBuild = "export GOTOOLCHAIN=local";

    ldflags = [
      "-s" "-w"
      "-X sigs.k8s.io/metrics-server/pkg/version.gitVersion=v${version}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "Scalable and efficient source of container resource metrics";
      homepage = "https://github.com/kubernetes-sigs/metrics-server";
      license = licenses.asl20;
    };
  };

in
mkImage {
  drv = metrics-server;
  name = "metrics-server";
  tag = "v${version}";
  entrypoint = [ "${metrics-server}/bin/metrics-server" ];
  cmd = [];

  labels = {
    "org.opencontainers.image.title" = "Kubernetes Metrics Server";
    "org.opencontainers.image.description" = "Scalable and efficient source of container resource metrics";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.chart" = "metrics-server";
  };
}
