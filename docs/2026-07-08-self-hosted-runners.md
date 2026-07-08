# Self-hosted (Talos) runners — capacity for builds & scans

Companion to the GHCR republish (#566). The republish stalled because the
per-letter build shards queue on GitHub-hosted runners that are out of
capacity/minutes. This documents the self-hosted runner capacity now available
and how to use it — **free, and packages still get CI-linked** (GITHUB_TOKEN
push auto-links).

## The runner label is `self-hosted` (not `arc-runners`)
The Talos ARC scale set for this repo:
- namespace `arc-runners-nixcontainers`, name/`runnerScaleSetName` = **`self-hosted`**
- attached to `github.com/nix-containers/images`, listener pod running in `arc-systems`
- **`runs-on: self-hosted`** to target it (arc-runners matches nothing → queues forever)

## Capacity: scaled 5 → 30
- `maxRunners` patched **5 → 30** (kubectl); Flux HelmRelease `arc-runner-nixcontainers`
  **suspended** so it holds. Nodes (pickhaus-001/002/003) = 50 CPU / 160 GB total.
- Durable fix TODO: set `maxRunners: 30` in the gitops HelmRelease values + re-enable Flux
  (`kubectl patch hr arc-runner-nixcontainers -n arc-systems --type merge -p '{"spec":{"suspend":false}}'`).

## How to run the republish on self-hosted (~1-3h vs stalled)
1. Merge **#572** — adds a `runner` input to `build-shard.yml` (threaded to build-and-push).
2. Re-dispatch each letter shard with `runner=self-hosted`:
   ```
   gh workflow run build-shard.yml -f prefix=a -f mode=push -f runner=self-hosted
   ```
   (c, k still need sub-sharding — >256.)
3. 30 runners + the in-cluster **Attic cache** (`arc-systems/attic`) → cache hits from
   prior builds. nixtop can **pre-warm Attic** (it built most images already); note nixtop
   *pushes* are unlinked, so it's cache-only, not the republish push.

## Related enabling PRs
- **#568** — security-scan: `self-hosted` daily schedule (09:00 UTC) + single-flight concurrency (no double scans)
- **#571** — opt-in multi-arch build (amd64 + arm64 via the Pi cluster's `self-hosted-arm64` set)
- **#572** — build-shard `runner` input (this republish unblock)
- Pi-cluster ARC manifests prepared (native arm64 build capacity)

## Runner input added to
`security-scan.yml`, `build-and-push.yml`, `build-containers.yml`, `auto-update-inline.yml`
(+ disk-space free step). All default `ubuntu-latest`; override to `self-hosted`.
