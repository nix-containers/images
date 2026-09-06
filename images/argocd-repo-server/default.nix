{ mkImage, pkgs, lib, ... }:

# Argo CD repo-server - serves and renders Git repository manifests
# https://github.com/argoproj/argo-cd
#
# Argo CD ships a single statically-linked binary whose behaviour is selected
# by the basename of argv[0]. Installing it as `argocd-repo-server` makes it
# run the repo-server component (matching the upstream image symlink layout).
#
# Prior revision consumed the upstream prebuilt Linux binary, which is
# Go-stdlib stale (34 high CVEs). Rebuild from source with current nixpkgs
# Go so stdlib patches forward at each build.

let
  version = "3.5.2";

  drv = pkgs.buildGoModule {
    pname = "argocd-repo-server";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "argoproj";
      repo = "argo-cd";
      rev = "v${version}";
      hash = "sha256-I3udVhmPpOA2Lf1mkJqG+d+mGpfM16HIKBkEnTiAw0c=";
    };

    proxyVendor = true;
    vendorHash = "sha256-w6jFNWKvcwxyeiSy+Pqb43qOfMOXF5UHr2VpyQD2dFw=";

    subPackages = [ "cmd" ];
    ldflags = [ "-s" "-w" ];
    env.CGO_ENABLED = 0;
    doCheck = false;

    # Upstream builds one binary at cmd/main.go (basename dispatch);
    # install as argocd-repo-server so the image entrypoint keeps working.
    postInstall = ''
      mv $out/bin/cmd $out/bin/argocd-repo-server
    '';

    meta = with lib; {
      description = "Argo CD repo-server (built from source)";
      homepage = "https://github.com/argoproj/argo-cd";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

in mkImage {
  inherit drv;
  name = "argocd-repo-server";
  tag = "v${version}";
  entrypoint = [ "${drv}/bin/argocd-repo-server" ];
  cmd = [ "--help" ];

  labels = {
    "org.opencontainers.image.title" = "argocd-repo-server";
    "org.opencontainers.image.description" = "Argo CD repository server";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.source" = "upstream-source";
  };
}
