# os-shell

Minimal shell image for Helm chart init containers: `/bin/bash`, GNU
coreutils and procps (`sysctl`, `ps`, `free`, ...). A CVE-clean replacement
for `bitnami/os-shell` / `bitnamilegacy/os-shell` in the common
"tune kernel parameters / fix volume permissions" init-container role.

## Build

```
nix build .#os-shell
nix run .#os-shell.copyTo -- oci:/tmp/os-shell:test
```

## Published tags

- `ghcr.io/nix-containers/images/os-shell:latest`
- `ghcr.io/nix-containers/images/os-shell:<bash-version>` (e.g. `:5.3p20`)

## Usage

Drop-in for a chart's sysctl init container (e.g. morgoved/wazuh-helm):

```yaml
indexer:
  sysctlImage:
    enabled: true
    images:
      repository: ghcr.io/nix-containers/images/os-shell
      tag: 5.3p20@sha256:<digest>
```

The image runs as UID 1001 by default; charts that run `sysctl -w` set
`runAsUser: 0` and `privileged: true` themselves.

## Related

- `os-shell-nixchart` — broader toolbox (util-linux, findutils, grep, sed,
  awk) for the nix-containers charts; no procps.
- `bash` — bash + coreutils only.
