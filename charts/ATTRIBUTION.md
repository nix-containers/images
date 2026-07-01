# Attribution

The charts in this directory were originally forked from
[bitnami/charts](https://github.com/bitnami/charts) — VMware/Broadcom's
Apache-2.0-licensed Helm chart library. The upstream `LICENSE.md` is
preserved as `LICENSE-BITNAMI.md` at the root of this directory per the
Apache-2.0 attribution requirement.

## Fork commit

The charts were pulled on 2026-07-01 from `bitnami/charts@main`.

## Modifications

Each chart in this directory is being progressively rewritten to:

- Default `image.repository` to nix-containers registry paths (typically the
  `-nixchart` variant of the corresponding image in `images/`).
- Remove Bitnami-specific script paths and env conventions where they aren't
  load-bearing for the chart's functionality.
- Simplify `values.yaml` — removing rarely-used configuration surface that
  most chart consumers never touch.
- Preserve behavioural compatibility with the Bitnami chart's Helm interface
  (values keys, templates, hooks) so existing chart consumers can swap the
  repo URL without needing to rewrite their overrides.

See each chart's `Chart.yaml` for its current version and the sources it
draws from.
