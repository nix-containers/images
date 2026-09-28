{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/grafana/loki

buildGoModule rec {
  pname = "loki";
  version = "3.7.8";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    hash = "sha256-H+4qSXf0gZL2RCf5o4v4V3/ozLVESdhy0QDEpXbAGuc=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/loki"
    "cmd/logcli"
    "clients/cmd/promtail"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/grafana/loki/v3/pkg/util/build.Version=${version}"
    "-X github.com/grafana/loki/v3/pkg/util/build.Branch=main"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Like Prometheus, but for logs";
    homepage = "https://grafana.com/oss/loki/";
    license = licenses.agpl3Only;
  };
}
