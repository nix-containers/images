# Cluster Image Audit — Tiberius-Grail (2026-06-12)

**Goal:** Map every image running on the two prod clusters to its `nix-containers/images`
counterpart, identify gaps, and drive the refresh-and-publish work.

**Spec:** see `docs/superpowers/specs/2026-06-12-cluster-image-audit-and-nix-containers-refresh-design.md`
(local-only, not in git).

## Status legend

- `up-to-date` — `nix-containers/images` already at upstream latest. No action.
- `needs-bump` — `nix-containers/images` exists but stale. Bump default.nix.
- `missing` — needed but no counterpart exists. Create new image dir.
- `out-of-scope` — GKE-managed; cannot replace.
- `deferred` — tiberius-grail/* internal; addressed in sub-project 2.
- `extra` — added by stakeholder request beyond the cluster scan (e.g. keycloak, redis).

## Audit table

| cluster image | cluster tag | nix-containers name | nix-containers ver | upstream latest | status | action |
|---|---|---|---|---|---|---|
| _populated by Task 3_ | | | | | | |

## Scan input (verbatim, 2026-06-12)

```
alpine/k8s    1.30.2    upstream    collected    1014    1d ago    1d ago
alpine/k8s    1.32.2    upstream    collected    989    1d ago    1d ago
alpine/k8s    1.35.3    upstream    collected    503    1d ago    1d ago
axllent/mailpit    v1.22    upstream    collected    148    1d ago    1d ago
cloudnative-pg/cloudnative-pg    1.27.1    upstream    collected    67    1d ago    1d ago
cloudnative-pg/postgis    18-3.6-system-trixie    upstream    collected    591    1d ago    1d ago
cloudnative-pg/postgresql    17    upstream    collected    407    1d ago    1d ago
cloudnative-pg/postgresql    17.2    upstream    collected    741    1d ago    1d ago
cloudnative-pg/postgresql    18    upstream    collected    407    1d ago    1d ago
cloudnative-pg/postgresql    18-system-trixie    upstream    failed    0    1d ago    1d ago
cloudnative-pg/postgresql    18.0-system-trixie    upstream    collected    552    1d ago    1d ago
curlimages/curl    8.5.0    upstream    collected    81    1d ago    1d ago
dragonflydb/dragonfly    v1.37.2    upstream    collected    167    1d ago    1d ago
external-dns/external-dns    v0.21.0    upstream    collected    46    1d ago    1d ago
external-secrets/external-secrets    v0.20.4    upstream    collected    85    1d ago    1d ago
fluxcd/helm-controller    v1.4.3    upstream    collected    149    1d ago    1d ago
fluxcd/helm-controller    v1.4.5    upstream    collected    146    1d ago    1d ago
fluxcd/image-automation-controller    v1.0.3    upstream    collected    156    1d ago    1d ago
fluxcd/image-automation-controller    v1.0.4    upstream    collected    155    1d ago    1d ago
fluxcd/image-reflector-controller    v1.0.3    upstream    collected    145    1d ago    1d ago
fluxcd/image-reflector-controller    v1.0.4    upstream    collected    144    1d ago    1d ago
fluxcd/kustomize-controller    v1.7.2    upstream    collected    243    1d ago    1d ago
fluxcd/kustomize-controller    v1.7.3    upstream    collected    242    1d ago    1d ago
fluxcd/notification-controller    v1.7.4    upstream    collected    149    1d ago    1d ago
fluxcd/notification-controller    v1.7.5    upstream    collected    148    1d ago    1d ago
fluxcd/source-controller    v1.7.3    upstream    collected    178    1d ago    1d ago
fluxcd/source-controller    v1.7.4    upstream    collected    175    1d ago    1d ago
fluxcd/source-watcher    v2.0.2    upstream    collected    144    1d ago    1d ago
fluxcd/source-watcher    v2.0.3    upstream    collected    137    1d ago    1d ago
forgejo/forgejo    15.0.3-rootless    upstream    collected    54    1d ago    1d ago
forgejo/runner    6.3.1    upstream    collected    187    1d ago    1d ago
gke-release/gke-release/anet/cni-writer    v0.1.40-gke.0@sha256:67f53cef809fb894cad4b99137539fe57f46a6a1e0346b1cd1f598fd92801093    upstream    collected    34    1d ago    1d ago
gke-release/gke-release/cilium/cilium    v1.18.7-gke1.35-gke.6@sha256:4922432d35b70c0b1b03de1210e3b205be8dffffec94f49302272c950ff5d611    upstream    collected    348    1d ago    1d ago
gke-release/gke-release/cluster-proportional-autoscaler    v1.10.2-gke.24@sha256:1d07b99750cfa777b55d7a66e73c4e4241dca6b215715478deb5793263a91527    upstream    collected    42    1d ago    1d ago
gke-release/gke-release/cluster-proportional-autoscaler    v1.10.3-gke.2@sha256:608476c370ab6d23cf62b3cb470b0480c446ff43fc6fa48959aa5d90f235722e    upstream    collected    41    1d ago    1d ago
gke-release/gke-release/csi-node-driver-registrar    v2.15.0-gke.26@sha256:f63211217e586411ba3703c247c1ef89154e5f86e8cbb2d44846d59d9de049a1    upstream    collected    23    1d ago    1d ago
gke-release/gke-release/event-exporter    event-exporter-v0.5.12-gke.6@sha256:addfe2a01f6689538a009c9b4757dee9aedf66aa05bde92b63f04a42bb85f368    upstream    collected    36    1d ago    1d ago
gke-release/gke-release/fluent-bit    v0.0.422-gke.2@sha256:4b5df304074c9f2842f16ef4869c0ec253c2d91d6478e5aa42d2f8dce9146b45    upstream    collected    126    1d ago    1d ago
gke-release/gke-release/fluent-bit-gke-exporter    v0.27.17-gke.20@sha256:67269cb89dbf9cf4e76e199a634c178eec76e74ae45694e8000893f7cae6179e    upstream    collected    50    1d ago    1d ago
gke-release/gke-release/gcp-compute-persistent-disk-csi-driver    v1.23.1-gke.10@sha256:b183a499a628a5ea60b4e7568a8a0b8242d6c9727f66d42ada8315c268e87e6b    upstream    collected    74    1d ago    1d ago
gke-release/gke-release/gke-distroless/bash    gke_distroless_20260207.00_p0@sha256:002b4b70bf122aaed02d9ba7158a5ce8424a5cc4342cc304ab6c254943f6a5da    upstream    collected    22    1d ago    1d ago
gke-release/gke-release/gke-distroless/bash    gke_distroless_20260323.00_p0@sha256:444559d524429bdc68860ebb6f02121dc75de1d2722c84753c629b411dbec983    upstream    collected    19    1d ago    1d ago
gke-release/gke-release/gke-metadata-server    gke_metadata_server_20260309.00_p0@sha256:2fd008f6a58022a2880e918c0f484e9f2680d55ef42176d43a3ba89efaa155ef    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-agent    1.16.1-gke.1@sha256:5f0830049d02cd37494d578f7b595a43cf4a5b5aaf1ac5fff4b9e3bcbe079a01    upstream    collected    38    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20250807_2300_RC0@sha256:aa1ed41571fa937da61b5bcd7cf842981c7f026b516c18655bc2f3a9362b1fa5    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20251007_2300_RC0@sha256:0d590a9fb5339909d425b2eede28ac05cc76346092cbe82602c7618f047c25f0    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20251009_2300_RC0@sha256:4c8e8cc4f739fc539e35c1581af031232d8885ee10f28484cb2085f5dfbb2b7d    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20260113_2300_RC0@sha256:5eb81dc265af031294a413a32fde1b59d5b8480e3f131a09b5a1059294aefd99    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20260121_2300_RC0@sha256:3cbd2b897c681db94832b4e03e58e4e2168666259507ff8fb8ae43a01a3b5f5d    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20260323_2300_RC0@sha256:05f11aa4dc486ad39b584546394ce895d23d141262f94017b3750f1836928f3e    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20260412_2300_RC0@sha256:fbc30ed703e17c3ae5622888145452d22865bb4f273db05321929a0fda0019a2    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/gke-metrics-collector    20260422_2300_RC0@sha256:70625564549ccc35d34e119dd3e3d5e2f841be9c309940d3ed5bb4e649a3c59f    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/ingress-gce-404-server-with-metrics    v1.38.6@sha256:33ba5db7cd2975bf956b6e1b6e2e32f51be424c1e29abebd60d441510b409d62    upstream    collected    24    1d ago    1d ago
gke-release/gke-release/k8s-dns-dnsmasq-nanny    1.26.8-gke.3@sha256:b5a2a5d776d611873573087f2caae2655122eb6354ca33856358331a1dcb9f2a    upstream    collected    70    1d ago    1d ago
gke-release/gke-release/k8s-dns-kube-dns    1.26.8-gke.3@sha256:e349d527bdfe0dfd02c26b38a94311415839ea30f48ca837d08ba5d9383f77cd    upstream    collected    37    1d ago    1d ago
gke-release/gke-release/k8s-dns-node-cache    1.26.8-gke.5@sha256:b466bc19f519bf5eb7ee278a57d33f9fdf253db8dd4e78677bd7b0373afcfea7    upstream    collected    114    1d ago    1d ago
gke-release/gke-release/k8s-dns-sidecar    1.26.8-gke.3@sha256:58eed94278e7b43ad2f4c302fd7457e4b5429e1296854d75c75ad45646e259d0    upstream    collected    37    1d ago    1d ago
gke-release/gke-release/kube-state-metrics    v2.14.0-gke.51@sha256:a346b3c4a95bf91641ed3facf8957fbb98823f92916d1cca356ad5c021cb1a4e    upstream    collected    35    1d ago    1d ago
gke-release/gke-release/metrics-server    v0.8.0-gke.18@sha256:815a7679647fb6b80a9455cfc8714a0a3cb4dc726fe623607cb97867ba7ab476    upstream    collected    51    1d ago    1d ago
gke-release/gke-release/netd    v0.10.12-gke.8@sha256:1aa11b6015e9372313038cb82ae76e78efc7631fce3f4df177cb8b329df61f49    upstream    collected    99    1d ago    1d ago
gke-release/gke-release/netd-init    v0.10.12-gke.8@sha256:035b66e2f6c307a04bc0a094b5194bdebb8e77ef6f1f7668021c37f0a4a425fa    upstream    collected    117    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20251006.01_p0@sha256:9042573fdb0db543b09002011fd5231eb1b0799bc345f40bd39454deaef0f7ab    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20251007.00_p0@sha256:638afa0822ed4c4aad9ff9f8528667a9d04dd5e1c7b1c251e9344ca7dd4aad68    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20251010.00_p0@sha256:3615589424e94c68f8cee5d50c27c5a8b1a1f50ab5dc175a14e8540db7c80e8e    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20251019.00_p0@sha256:2e1549e4692726aecc70364a1d6700cf276db2d9b4da90179284ca8de168c976    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20251023.00_p0@sha256:a7cb98da2747fc1e6cbce7c773fe9214fac03712b305ea6c0370392136b796a0    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20260222.00_p0@sha256:f1538ec13c7dbe0e95cd5aab7a25c29280d41a3909d86d400b43d66b54642da8    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20260312.00_p0@sha256:d31f982e00598633fd2e94787f76894e29e80a3d87f5e15eacfc42b40e866de8    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20260412.00_p0@sha256:10a31e4c4338b37a10dbf4dfeaabd58a95b711e59abb740de628c32748184831    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/node_token_broker/init    gke_node_token_broker_init_20260422.00_p0@sha256:4ceac22ea251c0996e6f58165c9b79b44bd98de251a4b38ffaf072a89974671c    upstream    collected    0    1d ago    1d ago
gke-release/gke-release/prometheus-engine/config-reloader    v0.18.0-gke.2@sha256:b41862ee7ee3e9f24112ccdb0e53060085af1a8347054a7dbcff04467d3e1e9c    upstream    collected    44    1d ago    1d ago
gke-release/gke-release/prometheus-engine/operator    v0.18.0-gke.2@sha256:c1096249d080e6763d41980b25cf237fd04091ba86abe7075f1e36b33b6fc263    upstream    collected    68    1d ago    1d ago
gke-release/gke-release/prometheus-engine/prometheus    v2.53.5-gmp.4-gke.0@sha256:6f349dc0be36c8a61be183254f1126c9935f5332daa96c481f7e0e1b20fe0513    upstream    collected    76    1d ago    1d ago
gke-release/gke-release/prometheus-to-sd    v0.12.4-gke.12@sha256:4ab422d9f7e9acffe18a43fc3ce910d37e04c38bf257437fdc09cbf33f3d7874    upstream    collected    36    1d ago    1d ago
gke-release/gke-release/proxy-agent    v0.34.0-gke.5@sha256:497745796db269a0e2d5257c4376bf8c64269e46119ab9b110b67592ef88372c    upstream    collected    25    1d ago    1d ago
google/cloud-sdk    slim    upstream    collected    865    1d ago    1d ago
grafana/grafana    13.0.1-security-01    upstream    collected    156    1d ago    1d ago
jetstack/cert-manager-cainjector    v1.20.2    upstream    collected    36    1d ago    1d ago
jetstack/cert-manager-controller    v1.20.2    upstream    collected    36    1d ago    1d ago
jetstack/cert-manager-webhook    v1.20.2    upstream    collected    36    1d ago    1d ago
joschi/forgejo-nix@sha256    504cd5fd5ab94753fdbbbb6fa85e65ca21ebcca388500fa6e9e73e47292ddecb    upstream    collected    132    1d ago    1d ago
kedacore/keda    2.20.1    upstream    collected    18    1d ago    1d ago
kedacore/keda-admission-webhooks    2.20.1    upstream    collected    14    1d ago    1d ago
kedacore/keda-metrics-apiserver    2.20.1    upstream    collected    18    1d ago    1d ago
kiwigrid/k8s-sidecar    2.7.3    upstream    collected    46    1d ago    1d ago
kube-state-metrics/kube-state-metrics    v2.18.0    upstream    collected    58    1d ago    1d ago
kyverno/background-controller    v1.18.1    upstream    collected    37    1d ago    1d ago
kyverno/cleanup-controller    v1.18.1    upstream    collected    37    1d ago    1d ago
kyverno/kyverno    v1.18.1    upstream    collected    37    1d ago    1d ago
kyverno/kyvernopre    v1.18.1    upstream    collected    37    1d ago    1d ago
kyverno/reports-controller    v1.18.1    upstream    collected    37    1d ago    1d ago
library/busybox    1.37.0    upstream    collected    3    1d ago    1d ago
library/postgres    15    upstream    collected    250    1d ago    1d ago
library/postgres    16-alpine    upstream    collected    79    1d ago    1d ago
library/python    3-alpine    upstream    collected    15    1d ago    1d ago
library/python    3.13-alpine    upstream    collected    16    1d ago    1d ago
minio/mc    latest    upstream    collected    110    22h ago    1d ago
nginxinc/nginx-unprivileged    alpine    upstream    collected    46    1d ago    1d ago
oauth2-proxy/oauth2-proxy    v7.7.1    upstream    collected    94    1d ago    1d ago
openfga/openfga    v1.17.1    upstream    collected    0    1d ago    1d ago
prom/alertmanager    v0.32.1    upstream    collected    40    1d ago    1d ago
prometheus/node-exporter    v1.11.1    upstream    collected    48    1d ago    1d ago
pulumi/pulumi    3.202.0-nonroot    upstream    failed    0    Never    1d ago
pulumi/pulumi-kubernetes-operator    v2.7.0    upstream    collected    57    1d ago    1d ago
release/pilot    1.30.1    upstream    collected    150    1d ago    1d ago
release/proxyv2    1.30.1    upstream    collected    145    1d ago    1d ago
rustfs/rustfs    1.0.0-alpha.89@sha256:c49a2be57774824f8f3caebae57edfd188e6ebc091d5ce768fe4b6e2a8451f4a    upstream    collected    82    1d ago    1d ago
rustfs/rustfs    1.0.0-beta.1@sha256:3c2d55977829620284ece8593901bf776bcfc0fc9972784352de4dcffdb92416    upstream    collected    62    1d ago    1d ago
stakater/reloader    v1.4.14    upstream    collected    37    1d ago    1d ago
tiberius-grail/agility    0.0.50    tiberius    collected    78    1d ago    1d ago
tiberius-grail/agility    0.0.51-rc1    tiberius    collected    78    1d ago    1d ago
tiberius-grail/agility    20260611-181739-cd905e76    tiberius    collected    78    1d ago    1d ago
tiberius-grail/agility    20260612-135138-68ea7a6f    tiberius    collected    80    12h ago    12h ago
tiberius-grail/agility    20260612-151651-3030ddf0    tiberius    collected    80    10h ago    10h ago
tiberius-grail/agility    20260612-210050-44fea579    tiberius    collected    80    4h ago    5h ago
tiberius-grail/assist    0.1.2    tiberius    collected    35    1d ago    1d ago
tiberius-grail/assist    20260528-140756-35abcb9f    tiberius    collected    35    1d ago    1d ago
tiberius-grail/blackknight    20260514-224738-a9a8a269    tiberius    collected    24    1d ago    1d ago
tiberius-grail/compliance    20260515-223152-ca3eb7b2    tiberius    collected    104    1d ago    1d ago
tiberius-grail/compliance    20260611-174804-fb82f5b9    tiberius    collected    104    1d ago    1d ago
tiberius-grail/compliance    20260611-195001-6a64fd92    tiberius    collected    104    1d ago    1d ago
tiberius-grail/compliance    20260612-182233-c96b9913    tiberius    collected    104    7h ago    8h ago
tiberius-grail/compliance-evidence-sidecar    20260303-175855-abed4131    tiberius    failed    0    1d ago    1d ago
tiberius-grail/effects    0.0.20    tiberius    collected    45    1d ago    1d ago
tiberius-grail/effects    0.0.20-rc4    tiberius    collected    45    1d ago    1d ago
tiberius-grail/effects    20260528-160437-916756f8    tiberius    collected    45    1d ago    1d ago
tiberius-grail/external-secrets    0.3.0-pr6353-f5abb191    tiberius    failed    0    1d ago    1d ago
tiberius-grail/forge-arc    20260528-005951-f138292b    tiberius    collected    22    1d ago    1d ago
tiberius-grail/golang-ai    0.0.20    tiberius    collected    80    1d ago    1d ago
tiberius-grail/golang-ai    0.0.20-rc4    tiberius    collected    80    1d ago    1d ago
tiberius-grail/golang-ai    20260528-160436-916756f8    tiberius    collected    80    1d ago    1d ago
tiberius-grail/grailed    20260423-124049-38b0b66    tiberius    collected    31    1d ago    1d ago
tiberius-grail/grailregistry    20260513-185802-e3f4911    tiberius    collected    447    1d ago    1d ago
tiberius-grail/grailsign    20260528-183014-023fc73f    tiberius    collected    47    1d ago    1d ago
tiberius-grail/rfd-api    latest    tiberius    collected    101    1d ago    1d ago
tiberius-grail/rfd-processor    latest    tiberius    collected    101    1d ago    1d ago
tiberius-grail/rfd-site    20260219-210222-c31897e9    tiberius    collected    216    1d ago    1d ago
tiberius-grail/swearjar    20260203-164114-be91cc5b    tiberius    collected    69    1d ago    1d ago
tiberius-grail/tiberius-com    20260611-210336-4da2869a    tiberius    collected    3    1d ago    1d ago
tiberius-grail/tiberius-com    20260612-144432-017641d5    tiberius    collected    3    11h ago    11h ago
tiberius-grail/tiberius-com    20260612-182930-a4cff0e7    tiberius    collected    3    7h ago    7h ago
tiberius-grail/tibui    20260608-205213-96e17384    tiberius    collected    25    1d ago    1d ago
timberio/vector    0.56.0-distroless-libc    upstream    collected    26    1d ago    1d ago
twentycrm/twenty    v2.9.0    upstream    collected    100    1d ago    1d ago
vaultwarden/server    1.36.0    upstream    collected    266    1d ago    1d ago
velero/velero    v1.17.1    upstream    collected    157    1d ago    1d ago
velero/velero-plugin-for-gcp    v1.13.1    upstream    collected    65    1d ago    1d ago
victoriametrics/operator    config-reloader-v0.69.0    upstream    collected    22    1d ago    1d ago
victoriametrics/operator    config-reloader-v0.70.1    upstream    collected    10    1d ago    1d ago
victoriametrics/operator    v0.70.1    upstream    collected    10    1d ago    1d ago
victoriametrics/victoria-logs    v1.50.0    upstream    collected    67    1d ago    1d ago
victoriametrics/victoria-metrics    v1.144.0    upstream    collected    43    1d ago    1d ago
victoriametrics/victoria-metrics    v1.145.0    upstream    collected    33    1d ago    1d ago
victoriametrics/vmagent    v1.142.0    upstream    collected    54    1d ago    1d ago
victoriametrics/vmagent    v1.144.0    upstream    collected    43    1d ago    1d ago
victoriametrics/vmalert    v1.143.0    upstream    collected    43    1d ago    1d ago
victoriametrics/vmalert    v1.144.0    upstream    collected    43    1d ago    1d ago
victoriametrics/vmalert    v1.145.0    upstream    collected    33    1d ago    1d ago
victoriametrics/vmauth    v1.136.0    upstream    collected    82    1d ago    1d ago
wait4x/wait4x    3.6    upstream    collected    145    1d ago    1d ago
zhaofengli/attic    latest    upstream    collected    8    1d ago    1d ago
zitadel/zitadel    v4.13.0    upstream    collected    88    1d ago    1d ago
zitadel/zitadel    v4.13.1    upstream    collected    79    1d ago    1d ago
zitadel/zitadel-login    v4.13.0    upstream    collected    112    1d ago    1d ago
zitadel/zitadel-login    v4.13.1    upstream    collected    105    1d ago    1d ago
```
