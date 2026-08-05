{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/grafana/loki

buildGoModule rec {
  pname = "loki";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "loki";
    rev = "v${version}";
    hash = "sha256-DzBhF90MV2lUj2ZMcWl7n8E/q6XVT99Qf7E4elQfXzo=";
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
