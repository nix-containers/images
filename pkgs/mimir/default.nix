{ lib, fetchFromGitHub, buildGoModule }:

# https://github.com/grafana/mimir

buildGoModule rec {
  pname = "mimir";
  version = "distributed-6.2.0-weekly.401";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mimir";
    rev = "mimir-${version}";
    hash = "sha256-ySay9vQxB09TVBDUG1tWTF4ptYtghioHWnP95mAyTDw=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/mimir"
    "cmd/mimirtool"
    "cmd/metaconvert"
    "cmd/query-tee"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s" "-w"
    "-X github.com/grafana/mimir/pkg/util/version.Version=${version}"
    "-X github.com/grafana/mimir/pkg/util/version.Branch=main"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Grafana Mimir provides horizontally scalable, highly available, multi-tenant, long-term storage for Prometheus";
    homepage = "https://grafana.com/oss/mimir/";
    license = licenses.agpl3Only;
  };
}
