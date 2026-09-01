{ mkImage, pkgs, lib, nonRoot, ... }:

# pulumi-kubernetes-operator built from upstream source (v2.9.0).
#
# nixpkgs has no `pulumi-kubernetes-operator` package. This image must be a
# drop-in for the upstream one, because the chart sets AGENT_IMAGE to the SAME
# image it runs the controller from (templates/deployment.yaml). That means the
# image is used in three distinct ways and all three must work:
#
#   1. controller     - chart passes args ["/manager", "--leader-elect", ...]
#   2. bootstrap init - operator runs `cp /agent /tini /share/` from it
#   3. workspace exec - the copied binaries run as
#                       `/share/tini /share/agent -- serve ...`
#
# Hence: BOTH binaries, plus tini, plus upstream's exact entrypoint contract.
#
# Do NOT set entrypoint to the manager binary. The chart passes "/manager" as
# the first element of `args`, and operator/cmd/main.go parses flags with the
# stdlib `flag` package, which stops at the first non-flag argument. With
# entrypoint=[manager] the effective argv is `manager /manager --leader-elect
# ...` and every flag is silently dropped -- leader election off, metrics bind
# address left at "0". The operator still starts and reports healthy, so this
# fails silently. Match upstream's ENTRYPOINT ["/tini","--"] + CMD ["/manager"].

let
  version = "2.9.0";

  pkoBin = pkgs.buildGoModule rec {
    pname = "pulumi-kubernetes-operator";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "pulumi";
      repo = "pulumi-kubernetes-operator";
      rev = "v${version}";
      hash = "sha256-Aw2cGvn3LpSm0NZMtlxi2dRbM9eZMZmZgNvQ6zbgY+o=";
    };

    # To bump: set vendorHash to lib.fakeHash, run `nix build`, copy the
    # "got:" value from the resulting hash-mismatch error.
    vendorHash = "sha256-8Kwd1Mq/gi8fsBfktKViXjV7glooiWxjJGv1ZNEUjY4=";

    # Single Go module (github.com/pulumi/pulumi-kubernetes-operator/v2);
    # `agent` is a subpackage, not a separate module.
    subPackages = [ "operator/cmd" "agent" ];

    ldflags = [
      "-w"
      "-X github.com/pulumi/pulumi-kubernetes-operator/v2/operator/version.Version=v${version}"
      "-X github.com/pulumi/pulumi-kubernetes-operator/v2/agent/version.Version=v${version}"
    ];

    env.CGO_ENABLED = 0;
    doCheck = false;

    # buildGoModule names each binary after its subPackage directory, so
    # operator/cmd installs as $out/bin/cmd. Upstream's chart invokes
    # /manager; rename to match. `agent` is already correctly named.
    postInstall = ''
      mv $out/bin/cmd $out/bin/manager
    '';

    meta = with lib; {
      description = "Pulumi Kubernetes Operator: manage Pulumi Stack CRs in-cluster";
      homepage = "https://github.com/pulumi/pulumi-kubernetes-operator";
      license = licenses.asl20;
      platforms = [ "x86_64-linux" "aarch64-linux" ];
    };
  };

  # Top-level symlinks. /manager is what the chart's args invoke; /agent and
  # /tini are what the bootstrap init container copies out with
  # `cp /agent /tini /share/`. Same pattern as the keda chart's /keda symlink
  # and the cloudnative-pg chart's /manager symlink.
  #
  # tini is deliberately NOT listed in mkImage's `extraPkgs` below. Any
  # package passed there is a *direct* member of the base layer's
  # `copyToRoot`, and nix2container flattens direct copyToRoot members by
  # stripping their own store-path prefix (so e.g. tini's bin/tini would be
  # relocated to /bin/tini, and /nix/store/<hash>-tini-*/bin/tini would no
  # longer exist). This symlink's target is that literal, unrewritten store
  # path, so it must reach tini only as an indirect closure reference (via
  # this derivation), exactly like /manager and /agent reach pkoBin -- pkoBin
  # is likewise never a direct `extraPkgs`/`extraContents` member, only the
  # image's `drv`. Verified empirically: with tini in extraPkgs, /tini
  # resolved to a dangling symlink; removing it fixed the bootstrap `cp`.
  rootCompat = pkgs.runCommand "pko-root-compat" {} ''
    mkdir -p $out
    ln -s ${pkoBin}/bin/manager $out/manager
    ln -s ${pkoBin}/bin/agent   $out/agent
    ln -s ${pkgs.tini}/bin/tini $out/tini
  '';
in
mkImage {
  drv = pkoBin;
  name = "pulumi-kubernetes-operator";
  tag = "v${version}";

  # Matches upstream's Dockerfile final stage exactly.
  entrypoint = [ "/tini" "--" ];
  cmd = [ "/manager" ];

  # tini is intentionally excluded here -- see the rootCompat comment above.
  extraPkgs = with pkgs; [ cacert tzdata ];
  extraContents = [ rootCompat ];

  labels = {
    "org.opencontainers.image.title" = "Pulumi Kubernetes Operator";
    "org.opencontainers.image.description" = "Manage Pulumi Stack CRs in-cluster";
    "org.opencontainers.image.version" = version;
    "io.nix-containers.image.upstream" = "https://github.com/pulumi/pulumi-kubernetes-operator";
    "io.nix-containers.image.category" = "operator";
  };

  user = nonRoot.userString;
}
