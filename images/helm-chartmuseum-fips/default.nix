{ mkImage, pkgs, lib, ... }:
# helm-chartmuseum-fips - https://github.com/helm/chartmuseum
# Built from source + GOTOOLCHAIN=local to clear stale Go-stdlib CVEs.
let
  version = "0.16.5";
  drv = pkgs.buildGoModule {
    pname = "helm-chartmuseum-fips"; inherit version;
    src = pkgs.fetchFromGitHub { owner = "helm"; repo = "chartmuseum"; rev = "v${version}"; hash = "sha256-LYREOjgW37Ab8aj5GswmYSiFz6ge4FCMrtzJNPdj4VE="; };
    vendorHash = "sha256-Xxj2DvNA84Py3FXFQjtOeM20fSScD6IVXX2nmfxaaGI=";
    subPackages = [ "cmd/chartmuseum" ];
    env.CGO_ENABLED = 0; preBuild = "export GOTOOLCHAIN=local"; ldflags = [ "-s" "-w" ]; doCheck = false;
  };
in mkImage { inherit drv; name = "helm-chartmuseum-fips"; tag = "v${version}"; entrypoint = [ "${drv}/bin/chartmuseum" ]; cmd = [ "--help" ]; labels = { "org.opencontainers.image.title" = "helm-chartmuseum-fips"; "org.opencontainers.image.version" = version; "io.nix-containers.source" = "upstream-source"; }; }
