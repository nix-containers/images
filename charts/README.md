# Helm Charts

Helm charts maintained by nix-containers, packaged as drop-in replacements for
Bitnami's Apache-2.0 charts.

## Layout

- Each subdirectory is one chart (e.g. `charts/postgresql/`).
- Charts default their `image.repository` to the matching `-nixchart` image
  from this repo's registry.
- `LICENSE` and `NOTICE` files are preserved from the upstream Bitnami chart
  at the time of fork (Apache-2.0), per the license's attribution requirements.

## Naming — why `-nixchart`?

Container images that are shaped for Helm chart consumption (Bitnami-style
entrypoint contracts, non-root defaults, `/opt/bitnami/scripts/`-compatible
layout) carry the `-nixchart` suffix in this repo. When you see a Chart.yaml
here that references `postgresql-nixchart`, it means: this variant of the
image is the one shipped with (and tested against) this chart.

## Not forked here

Images that pair with upstream project-official charts (Flux, cert-manager,
ingress-nginx, prometheus-operator) are documented in the per-image
description on the website, with a link to the upstream chart repo. We don't
fork those charts because the upstream ones are maintained by their
respective projects and don't need a Bitnami-compat layer.
