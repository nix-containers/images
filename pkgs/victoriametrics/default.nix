{
  lib,
  buildGoModule,
  fetchFromGitHub,
  withServer ? true, # the actual metrics server
  withVmAgent ? true, # Agent to collect metrics
  withVmAlert ? true, # Alert Manager
  withVmAuth ? true, # HTTP proxy for authentication
  withBackupTools ? true, # vmbackup, vmrestore
  withVmctl ? true, # vmctl is used to migrate time series
}:

# VictoriaMetrics core v1.145.0
# https://github.com/VictoriaMetrics/VictoriaMetrics

buildGoModule (finalAttrs: {
  pname = "VictoriaMetrics";
  # Was pinned to "pmm-6401-v1.152.0" -- a tag from Percona's PMM fork of
  # VictoriaMetrics (branch-numbered PR tags), not the real upstream
  # VictoriaMetrics/VictoriaMetrics release, so both the ref AND the hash
  # were wrong (verified: nix-prefetch-github against the real v1.152.0 tag
  # returns a DIFFERENT hash than what was here). Corrected to the real
  # upstream tag and its real hash.
  version = "1.152.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3PDFQbVJhwyMUvA/ToXJKBOIN9xKoBGp/YjHntjwKr4=";
  };

  vendorHash = null;
  env.CGO_ENABLED = 0;

  subPackages =
    lib.optionals withServer [
      "app/victoria-metrics"
      "app/vminsert"
      "app/vmselect"
      "app/vmstorage"
      "app/vmui"
    ]
    ++ lib.optionals withVmAgent [ "app/vmagent" ]
    ++ lib.optionals withVmAlert [
      "app/vmalert"
      "app/vmalert-tool"
    ]
    ++ lib.optionals withVmAuth [ "app/vmauth" ]
    ++ lib.optionals withVmctl [ "app/vmctl" ]
    ++ lib.optionals withBackupTools [
      "app/vmbackup"
      "app/vmrestore"
    ];

  postPatch = ''
    # main module (github.com/VictoriaMetrics/VictoriaMetrics) does not contain package
    # github.com/VictoriaMetrics/VictoriaMetrics/app/vmui/packages/vmui/web
    #
    # This appears to be some kind of test server for development purposes only.
    rm -f app/vmui/packages/vmui/web/{go.mod,main.go}

    # Relax go version to major.minor
    sed -i -E 's/^(go[[:space:]]+[[:digit:]]+\.[[:digit:]]+)\.[[:digit:]]+$/\1/' go.mod
    sed -i -E 's/^(## explicit; go[[:space:]]+[[:digit:]]+\.[[:digit:]]+)\.[[:digit:]]+$/\1/' vendor/modules.txt

    # Increase timeouts in tests to prevent failure on heavily loaded builders
    substituteInPlace lib/storage/storage_test.go \
      --replace-fail "time.After(10 " "time.After(120 " \
      --replace-fail "time.NewTimer(30 " "time.NewTimer(120 " \
      --replace-fail "time.NewTimer(time.Second * 10)" "time.NewTimer(time.Second * 120)"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${finalAttrs.version}"
  ];

  preCheck = ''
    # `lib/querytracer/tracer_test.go` expects `buildinfo.Version` to be unset
    export ldflags=''${ldflags//=${finalAttrs.version}/=}
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://victoriametrics.com/";
    description = "Fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = lib.licenses.asl20;
    changelog = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v${finalAttrs.version}";
    mainProgram = "victoria-metrics";
  };
})
