# Talos runner scale-set: right-sizing + Attic

Fixes control-plane stress from unbounded runners and enables the Attic cache
(see build-and-push PR — `attic use`/`push` are wired there).

## 1. Right-size (values-patch.yaml)
Merge `values-patch.yaml` into the `arc-runner-nixcontainers` HelmRelease
`.spec.values`. Adds resource requests/limits (so k8s caps concurrency
naturally) and sets `maxRunners: 16`. Then un-suspend Flux — it currently holds
the live `maxRunners: 12` patch:
```
kubectl patch hr arc-runner-nixcontainers -n arc-systems --type merge -p '{"spec":{"suspend":false}}'
```

## 2. Attic token (enables the cache from build-and-push)
Mint a push/pull token on the Attic server and store it in the runner secret:
```
# on the attic server pod:
atticadm make-token --sub ci-runner --validity '1 year' \
  --pull 'nixcontainers' --push 'nixcontainers' --create-cache 'nixcontainers'
# then:
kubectl create secret generic attic-runner-token \
  -n arc-runners-nixcontainers --from-literal=token='<TOKEN>' \
  --dry-run=client -o yaml | kubectl apply -f -
```
The ARC template already injects `ATTIC_TOKEN` from `attic-runner-token`
(optional). Once populated, build-and-push's `attic use`/`push` activate and
shared closures start caching.

## Numbers
Nodes: 50 CPU / 160 GB total. At 2 CPU + 6 GB request/runner (+dind 1/2), ~12-16
runners fit; extras stay Pending. That's the natural cap that keeps etcd calm.
