#!/usr/bin/env bash
# Test Tempo with nix-containers images
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(dirname "$(dirname "$SCRIPT_DIR")")/scripts/helpers.sh"

NAMESPACE="tracing"
RELEASE="tempo"

echo "Testing Tempo deployment..."

# Cleanup any previous installation
helm_uninstall "$RELEASE" "$NAMESPACE"

# Install Tempo
helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null || true
helm repo update grafana 2>/dev/null || true
helm_install "$RELEASE" grafana/tempo "$NAMESPACE" \
    --set tempo.image.repository=nix-containers/tempo \
    --set tempo.image.tag=test

# Wait for deployment
wait_for_pod "$NAMESPACE" "app.kubernetes.io/name=tempo"

# Verify release status
check_helm_release "$RELEASE" "$NAMESPACE"

# Cleanup
helm_uninstall "$RELEASE" "$NAMESPACE"

echo "Tempo test passed!"
