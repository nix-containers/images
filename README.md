# Nix Containers

A collection of container images built with nix2container, featuring dynamic discovery and multi-layer architecture.

**Browse all images:** **[nix-containers.github.io/images](https://nix-containers.github.io/images/)** — searchable catalog with per-image pages showing descriptions, vulnerability scans, SBOMs, chart usage, and source.

## Architecture

- **Auto-build latest images** - Multiple patterns to build latest images securely (nix pipeline and github actions) 
- **Support building on Linux or MacOS (with lima)**
- **Pull and package latest upstream charts with the nix containers**
- **E2E image testing with the charts** - Testing with live cluster (kind)
- **CVE scanning** - Trivy/Grype
- **Multi-layer images** - Base packages in separate layers for better caching
- **Non-root users** - All images run as UID 1000 for security
- **Dynamic discovery** - Images automatically discovered from `images/` folder
- **Shared libraries and layers** - Common functionality in `lib/` folder
  - `base.nix` - Common packages, environment, and labels - optional layer
  - `nonRoot.nix` - A common Non-root user configuration - optional layer
  - `devShell.nix` - Development shell configurations with bash and dev tools
  - `buildCLIImage.nix` - CLI application wrapper
  - `mkUserEnvironment.nix` - User environment setup


## Container Image Ecosystem Comparison

<div align="center">

| Provider | <img src="https://nixos.org/favicon.ico" width="20" height="20"> Nix Containers | <img src="https://images.chainguard.dev/favicon.svg" width="20" height="20"> Chainguard | <img src="https://securebuild.com/favicon.ico" width="20" height="20"> Replicated SecureBuild |
|----------|:-----------:|:-----------:|:-----------:|
| **Public Images** | **3,118** | **51** | **31 (zero public)** |
| **Build System** | Nix + nix2container | apko + melange | Buildpacks |
| **Base** | NixOS/nixpkgs | Alpine/glibc | Various |
| **Security Focus** | Reproducible builds & minimal attack surface | Minimal attack surface | Supply chain security |
| **License** | Open Source | Open Source For Now | Commercial |

</div>

*Last updated: 2025-12-12*

### Image Breakdown by Category

| Category | Count | Description |
|----------|------:|-------------|
| **FIPS-140-2 Compliant** | 955 | BoringCrypto-enabled Go binaries |
| **Kubernetes** | 236 | Core k8s components, kubectl, operators |
| **Crossplane** | 129 | Crossplane providers and controllers |
| **Prometheus/Exporters** | 123 | Monitoring and metrics exporters |
| **Flux Controllers** | 108 | GitOps controllers and components |
| **GitLab** | 49 | GitLab runner, shell, pages, registry |
| **Grafana Stack** | 42 | Grafana, Loki, Tempo, Mimir |
| **Cilium/Hubble** | 39 | CNI networking and observability |
| **AWS** | 38 | EBS/EFS CSI drivers, load balancer |
| **Argo** | 32 | ArgoCD, Rollouts, Workflows, Events |
| **Kyverno** | 32 | Policy engine and controllers |
| **Calico** | 30 | CNI networking components |
| **Harbor** | 26 | Container registry components |
| **cert-manager** | 25 | Certificate management |
| **NeuVector** | 15 | Container security platform |
| **OpenTelemetry** | 13 | Tracing and observability |
| **Istio** | 13 | Service mesh components |
| **Keycloak** | 13 | Identity and access management |
| **Velero** | 11 | Backup and disaster recovery |
| **Thanos** | 10 | Long-term Prometheus storage |
| **Vault** | 7 | Secrets management |
| **External (DNS/Secrets)** | 7 | External integrations |
| **Trivy** | 5 | Vulnerability scanning |
| **Other** | ~1,100+ | Base images, runtimes, databases, tools |

---
## Local Development

### Quick Start (Makefile "Training Wheels")

The Makefile provides convenient shortcuts for common tasks - especially useful if you're new to Nix:

```bash
# See all available commands
make help

# Test everything
make verify                    # Run 3 verification tests
make test-all                 # Build and test all images
make list-images              # List available images

# Test specific images
make test-image IMAGE=bash    # Test single image
make test-bash                # Quick test for bash image
```

### Pure Nix Commands (Advanced)

If you prefer using Nix directly without the Makefile abstraction:

```bash
# Discovery using lib.filesystem.listFilesRecursive
nix eval --json .#discoveredImages

# Build and load specific images
nix build .#load-<image-name>-to-docker
# Example:
nix build .#load-sops-to-docker

# Build and load all images at once
nix build .#load-all-to-docker && ./result/bin/load-all-to-docker

# Run comprehensive test suite
nix run .#test-all-images

# Image discovery script
nix run .#discover-images
```

### Why Both Makefile and Nix?

The **Makefile serves as "training wheels"** for developers:
- **Familiar interface**: `make test` is more intuitive than complex Nix commands
- **Documentation**: `make help` shows available tasks without knowing Nix
- **IDE integration**: Most editors understand Makefiles for task running
- **Onboarding**: New contributors can be productive without learning Nix first

The **Nix commands are the "real" implementation**:
- More powerful and flexible
- Direct access to all flake outputs
- Better integration with Nix ecosystem
- Required for advanced workflows

### Verify Images in Docker

```bash
# List loaded images
docker images | grep -E "(cpp-runtime|cpp-build-env|rust-build-env|kubectl|dragonfly-operator|external-dns|sops-base)"
```

## Registry Management

### Tag and Push to Different Registry

After building images locally, you can retag and push them to your own registry:

```bash
# Tag and push cpp-runtime
docker tag cpp-runtime your-registry.com/cpp-runtime:latest
docker push your-registry.com/cpp-runtime:latest

# Tag and push cpp-build-env
docker tag cpp-build-env your-registry.com/cpp-build-env:latest
docker push your-registry.com/cpp-build-env:latest

# Tag and push rust-build-env
docker tag rust-build-env your-registry.com/rust-build-env:latest
docker push your-registry.com/rust-build-env:latest

# Tag and push kubectl
docker tag kubectl your-registry.com/kubectl:latest
docker push your-registry.com/kubectl:latest

# Tag and push dragonfly-operator
docker tag dragonfly-operator your-registry.com/dragonfly-operator:latest
docker push your-registry.com/dragonfly-operator:latest

# Tag and push external-dns
docker tag external-dns your-registry.com/external-dns:latest
docker push your-registry.com/external-dns:latest

# Tag and push sops-base
docker tag sops-base your-registry.com/sops-base:latest
docker push your-registry.com/sops-base:latest
```

### Bulk Push Script

```bash
#!/bin/bash
REGISTRY="your-registry.com"
IMAGES_RAW=($(find images -name "default.nix" -exec dirname {} \; | sort | xargs -I {} basename {}))

for image in "${IMAGES[@]}"; do
    echo "= Pushing $image..."
    docker tag "$image" "$REGISTRY/$image:latest"
    docker push "$REGISTRY/$image:latest"
    echo " $image pushed successfully!"
done
```

## Checking for Package Updates

Use `nvchecker` to check for upstream version updates:

```bash
# Check for updates to custom packages in pkgs/
nix-shell -p nvchecker --run "nvchecker -c nvchecker.toml && nvcmp -c nvchecker.toml"
```

This compares versions in `old_versions.json` against the latest GitHub releases for packages like cilium, cert-manager, cloudnative-pg, keda, etc.

## Development Environment

```bash
# Enter development shell with all tools
nix develop
```

The development shell includes:
- **nix** - Nix package manager and build tools
- **docker** & **docker-compose** - Container runtime and orchestration
- **jq** - JSON processing for workflow debugging
- **git** & **gh** - Version control and GitHub CLI
- **just** & **gnumake** - Build automation tools

### Using Development Shell Library

The `lib/devShell.nix` library provides reusable development shell configurations:

```nix
# In your image's default.nix
{ pkgs, ... }:
let
  devShell = pkgs.callPackage ../lib/devShell.nix {};
in {
  # Use predefined shells
  packages = devShell.minimalDevShell.packages;     # bash + basic tools
  packages = devShell.standardDevShell.packages;    # + extended utilities  
  packages = devShell.fullDevShell.packages;        # + programming & container tools
  
  # Create custom shell
  packages = (devShell.mkDevShell {
    extraPackages = [ pkgs.htop pkgs.tmux ];
    includeBasic = true;
    includeExtended = true;
    includeProgramming = false;
  }).packages;
}
```