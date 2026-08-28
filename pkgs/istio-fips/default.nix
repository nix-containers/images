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

{ lib, fetchFromGitHub, buildGoModule }:

let
  version = "1.30.4";

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
}
