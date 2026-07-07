# GHCR Republish, 2026-07-07

State snapshot from a one-time cleanup pass on 2026-07-07. Verify against the current registry before acting on anything below.

## What got deleted (and why)

- **~52 bogus `~atest`-suffixed packages** — typos where a `-latest` tag ending up appended to the *name* instead of the tag (`chartmuseumatest`, `helm-mapkubeapisatest`, `spegelatest`, etc.). These are the fingerprint of a push-script bug: the tag argument leaked into the destination ref. Root-cause fix still open — check wherever `scripts/local-build-push.sh` or an Actions push step assembles the destination ref.
- **~244 private packages** — pushed from a laptop (via `scripts/local-build-push.sh`) at a time when the org's default package visibility was private. Never inherited the source-repo link on subsequent Actions pushes.
- **~1539 public-but-unlinked packages** — same origin story, minus the visibility bit.

Total: **~1835 packages deleted**.

## Why deleting is the right move

GHCR packages implicitly ACL to the original pusher. Only workflows in a *linked* repo also get write via the workflow's `GITHUB_TOKEN`. Unlinked packages therefore fail CI pushes with:

```
denied: installation not allowed to Write organization package
```

There is **no REST API** to change either the visibility or the source-repo link on an existing package. The workflow at `.github/workflows/fix-package-visibility.yml` documents this frustration in its docstring; direct tests against the `/visibility` PATCH endpoint return HTTP 404 regardless of scope, and the header `X-Accepted-OAuth-Scopes` is absent — GitHub isn't gating the endpoint, it simply doesn't exist.

The only reliable way to get both fields correct is:

1. **Delete** the package.
2. **Re-push from Actions** using `GITHUB_TOKEN`.
3. First-push auto-links the package to the source repo AND inherits the repo's visibility (public in this org).

## Left undeleted

- **~62 packages** that are unlinked but either lack an `images/<name>/` source dir (can't be rebuilt from this repo) OR had a placeholder `sha256-AAAAA…=` `vendorHash` that would fail the CI build. These stay orphaned until the underlying issue is repaired.
- **~104 image `default.nix` files** with placeholder `vendorHash`. These are always-failing builds — never usable via CI or `local-build-push.sh`. Run `scripts/fix-hashes.sh --all` to iteratively derive real hashes from the build-error output. Expect ~5-10 minutes per image (each iteration re-runs `nix build` until the hash mismatch surfaces), so a full sweep is many hours.

## In-flight state (2026-07-07 23:00 UTC)

Rebuild wave dispatched. **Live progress tracker: issue #566** — has a checkbox list of every `build-shard.yml` run keyed by prefix + run ID. Update that issue when a shard succeeds/fails rather than editing this doc.

- 23 single-letter shards dispatched (a, b, d-j, l-t, v-z; u already ran green as smoke test)
- 31 sub-shards for oversized letters c (15) and k (16); all sub-prefixes ≤ 256 job cap
- Fresh Security Scan dispatched but queued behind the shard drain — its intermediate output will look bad (many packages still mid-rebuild); wait for the last shard before treating scan numbers as real

Package count is climbing as pushes land: **830 → 897 in the first ~20 min after dispatch**.

## Rebuilding the deleted set

Use `build-shard.yml` — a workflow-dispatch that builds every image whose name starts with a given prefix, capped at the 256-job GitHub matrix limit:

```
gh workflow run build-shard.yml --ref main -f prefix=<letter> -f mode=push
```

Letters `c` (416 image dirs) and `k` (381) exceed 256 and need sub-sharding (`prefix=ca`, `prefix=cb`, …). Every other single-letter prefix fits in one dispatch.

Because the delete removed the first-push privilege for these packages, CI's next push under any of these prefixes will (a) create the package, (b) link it to `nix-containers/images` as the source repo, (c) inherit public visibility.

## Related workflows / scripts

- `.github/workflows/fix-package-visibility.yml` — attempts the (non-existent) visibility PATCH endpoint; kept for future GitHub API additions.
- `.github/workflows/auto-update-inline.yml` — scheduled bump for inline-fetch images; touches the same push path.
- `scripts/fix-hashes.sh` — placeholder-hash repair loop.
- `scripts/bump-inline-image.sh` — companion for version-bump-driven hash refresh.
