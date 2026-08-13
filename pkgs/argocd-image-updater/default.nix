{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/argoproj-labs/argocd-image-updater

buildGoModule rec {
  pname = "argocd-image-updater";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = "argocd-image-updater";
    rev = "v${version}";
    hash = "sha256-OK64G5moyKuLZFFt1XDbSESL2k4D0NA9KTKLVreEPlE=";
  };

  vendorHash = "sha256-8r+XThKzH5619Su+sxK83CF8XuSFGtLXMKZOHgWQR7c=";

  subPackages = [ "cmd" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/argoproj-labs/argocd-image-updater/pkg/version.version=${version}"
    "-X github.com/argoproj-labs/argocd-image-updater/pkg/version.gitCommit=unknown"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/argocd-image-updater
  '';

  doCheck = false;

  meta = with lib; {
    description = "Automatic container image updater for Argo CD";
    homepage = "https://github.com/argoproj-labs/argocd-image-updater";
    license = licenses.asl20;
  };
}
