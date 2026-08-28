# istio-fips - Istio Go control-plane components built with BoringCrypto
# https://github.com/istio/istio
#
# WHY THIS EXISTS SEPARATELY FROM pkgs/istio. pkgs/istio extracts prebuilt
# binaries out of the official Istio release images, which are stock upstream
# builds using Go's default crypto. Extraction can never produce a FIPS
# artifact, so a -fips variant sourced that way is a name and nothing more.
# This package builds from istio/istio source with CGO_ENABLED=1 and
# GOEXPERIMENT=boringcrypto, the same mechanism the 286 genuinely-qualifying
# -fips images here use (see pkgs/cert-manager-fips).
#
# SCOPE, AND ITS LIMIT. pilot-discovery (istiod) and pilot-agent are pure Go, so
# boringcrypto applies. The Envoy data plane is C++ and CANNOT be built this way
# at all: it needs Bazel --define boringssl=fips against the frozen
# FIPS-validated BoringSSL. Envoy terminates external TLS at the ingress
# gateway, so this package covers the control plane and mTLS/xDS crypto, NOT the
# edge. Do not read it as "Istio is FIPS".
#
# Verify a build with:
#   go version -m result/bin/pilot-discovery | grep GOEXPERIMENT
# which must report boringcrypto. A binary without that line is not a FIPS
# build regardless of what the derivation is called.

{ lib, fetchFromGitHub, buildGoModule, fetchurl, stdenvNoCC, autoPatchelfHook, zlib, stdenv, runCommand, cacert }:

let
  version = "1.30.4";

  # PROXY_REPO_SHA from istio/istio istio.deps at tag 1.30.4.
  proxySha = "ce177c56fe75661f16b654e2f164d4ab02058222";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    hash = "sha256-v/fcC+rtU5ScKjiRfgJ/CC4G1+DbaYri9BG146is+AA=";
  };

  commonAttrs = {
    inherit version src;
    # CGO must be on: boringcrypto swaps Go's crypto for cgo calls into
    # BoringCrypto, so CGO_ENABLED=0 silently produces a NON-FIPS binary while
    # still accepting the GOEXPERIMENT flag.
    env.CGO_ENABLED = 1;
    env.GOEXPERIMENT = "boringcrypto";
    doCheck = false;
    meta = with lib; {
      homepage = "https://istio.io/";
      license = licenses.asl20;
      platforms = platforms.linux;
    };
  };

in
rec {
  inherit version src;

  pilot-discovery = buildGoModule (commonAttrs // {
    pname = "pilot-discovery-fips";
    vendorHash = "sha256-CEoahz/BPtKpsjvjB/FQKDX9QEk9mycCtMSOSPZbL3o=";
    subPackages = [ "pilot/cmd/pilot-discovery" ];
    ldflags = [
      "-s" "-w"
      "-X istio.io/istio/pkg/version.buildVersion=${version}"
      "-X istio.io/istio/pkg/version.buildStatus=Clean"
    ];
    meta = commonAttrs.meta // {
      description = "Istio control plane (istiod), BoringCrypto build";
      mainProgram = "pilot-discovery";
    };
  });

  pilot-agent = buildGoModule (commonAttrs // {
    pname = "pilot-agent-fips";
    vendorHash = "sha256-CEoahz/BPtKpsjvjB/FQKDX9QEk9mycCtMSOSPZbL3o=";
    subPackages = [ "pilot/cmd/pilot-agent" ];
    ldflags = [
      "-s" "-w"
      "-X istio.io/istio/pkg/version.buildVersion=${version}"
    ];
    meta = commonAttrs.meta // {
      description = "Istio sidecar agent, BoringCrypto build";
      mainProgram = "pilot-agent";
    };
  });

  # BoringSSL-FIPS Envoy, fetched by hash from a GitHub release.
  #
  # WHY NOT BUILT HERE. This is a ~75 minute Bazel build that needs network
  # access mid-build and its own clang/cmake/ninja/go toolchain, so it cannot
  # run in a nix derivation. scripts/build-istio-envoy-fips.sh is the exact
  # recipe and regenerates this artifact; the hash below pins it, so the IMAGE
  # stays reproducible from git even though the binary is a documented input.
  #
  # WHY NOT UPSTREAM ENVOY. Istio's data plane needs istio/proxy's build — the
  # bootstrap requires type.googleapis.com/istio.workload.BootstrapExtension and
  # the binary must carry io.istio.http.peer_metadata, io.istio.local_principal
  # and io.istio.peer_principal. Chainguard's envoy-fips is upstream Envoy and
  # rejects Istio's config; Google's ASM ships no FIPS variant; Tetrate's is
  # subscription-gated. Nothing publishes a FIPS Envoy Istio can use.
  #
  # Built from PROXY_REPO_SHA ce177c56 (istio 1.30.4's pin) with
  # --config=boringssl-fips. Reports:
  #   ce177c56.../1.38.4-dev/Clean/RELEASE/BoringSSL-FIPS
  # Envoy always links BoringSSL, so that suffix is the only thing separating a
  # FIPS build from a stock one.
  #
  # autoPatchelfHook IS LOAD-BEARING. The Bazel build emits a binary requesting
  # /lib64/ld-linux-x86-64.so.2, absent in a nix image. Without patching,
  # pilot-agent fails with "fork/exec /usr/local/bin/envoy: no such file or
  # directory" — ENOENT for the missing INTERPRETER, not the missing file, which
  # is thoroughly misleading. Patching does not disturb the crypto; the patched
  # binary still reports BoringSSL-FIPS.
  #
  # NOT CMVP-VALIDATED. See the fips.* labels on images/istio-proxyv2-fips and
  # the header of the build script.
  envoy = stdenv.mkDerivation {
    pname = "istio-envoy-boringssl-fips";
    inherit version;

    src = fetchurl {
      url = "https://github.com/nix-containers/images/releases/download/istio-envoy-fips-1.30.4/istio-envoy-fips-${proxySha}.gz";
      hash = "sha256-JitAZRmjGTAdlmkDBe67AxlQHYbuWi+WhYtp1608Suo=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib zlib ];

    unpackPhase = "true";
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      gzip -dc $src > $out/bin/envoy
      chmod 755 $out/bin/envoy
      runHook postInstall
    '';
    dontStrip = true;
  };

  # OS CA bundle under the filename istio actually probes.
  #
  # pilot-agent calls security.GetOSRootFilePath(), which stats a fixed list of
  # distro paths and takes the first hit:
  #   /etc/ssl/certs/ca-certificates.crt   (Debian/Ubuntu — first, so this one)
  #   /etc/pki/tls/certs/ca-bundle.crt, /etc/ssl/ca-bundle.pem, ... (7 more)
  # nixpkgs cacert installs the bundle as /etc/ssl/certs/ca-bundle.crt, which
  # matches NONE of them — note the second candidate IS ca-bundle.crt but under
  # /etc/pki/tls/certs, not /etc/ssl/certs. So the bundle was present all along
  # under a name istio never looks for, and every proxy logged
  #   warn  OS CA Cert could not be found for agent
  # while upstream proxyv2, being Debian-based, did not.
  #
  # Inert on our clusters today — nothing makes the proxy fetch remote JWKS over
  # TLS (no RequestAuthentication, no jwt_authn filter, and the ext_authz
  # provider is plaintext in-cluster gRPC) — but it is a real divergence from
  # upstream that would bite the moment a RequestAuthentication with a remote
  # jwksUri is added, and it would surface as a TLS verification error rather
  # than anything pointing back here.
  osCaCompat = runCommand "istio-os-ca-certificates" { } ''
    mkdir -p $out/etc/ssl/certs
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt \
          $out/etc/ssl/certs/ca-certificates.crt
  '';

  # Combined image payload, mirroring pkgs/istio's proxyv2-bin layout:
  # binaries in /bin plus the /usr/local/bin symlinks pilot-agent looks for, and
  # the bootstrap template at the path Envoy is handed.
  #
  # PARTIAL FIPS, DELIBERATELY. pilot-agent is BoringCrypto; envoy is not. The
  # gateway's external TLS is terminated by ENVOY, so this does not make the
  # edge FIPS — it makes the agent that manages it FIPS. Labelled accordingly.
  proxyv2-bin = stdenvNoCC.mkDerivation {
    pname = "istio-proxyv2-fips";
    inherit version;
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/usr/local/bin $out/var/lib/istio/envoy
      cp ${envoy}/bin/envoy $out/bin/
      cp ${pilot-agent}/bin/pilot-agent $out/bin/
      ln -s $out/bin/envoy $out/usr/local/bin/envoy
      ln -s $out/bin/pilot-agent $out/usr/local/bin/pilot-agent
      cp ${src}/tools/packaging/common/envoy_bootstrap.json \
         $out/var/lib/istio/envoy/envoy_bootstrap_tmpl.json
      runHook postInstall
    '';
    meta = with lib; {
      description = "Istio proxyv2 payload: BoringCrypto pilot-agent + stock Envoy + bootstrap";
      homepage = "https://istio.io/";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };
}
