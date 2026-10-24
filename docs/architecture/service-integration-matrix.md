# Service integration matrix (sanitized)

Fill real hosts/ports only in `docs/private/service-integration-matrix.local.md` (gitignored).

| Source | Destination | Purpose | Auth | Notes |
|--------|-------------|---------|------|-------|
| Clients | Live Jellyfin (NAS Apps) | Playback | Jellyfin users | Via LAN or private VPN |
| Clients | k8s Jellyfin (future) | Validation | Separate users | After ingress |
| CI | GHCR | Image publish | OIDC/PAT | No prod secrets on fork PRs |
| Terraform runner | TrueNAS S3 | Remote state and lockfile | Dedicated bucket-scoped key | TLS, versioning, independent backup |
| Argo CD | Git | Desired state | Deploy key | |
| Argo CD | Approved Helm repositories | Platform charts | Repository allowlist | Versions pinned in Applications |
| Argo CD | kube-apiserver | Apply | RBAC SA | |
| Apps | Vault | Runtime secrets | K8s auth / injector | Vault must be initialized and unsealed |
| Jellyfin k8s | NFS media | Read media | Export ACLs | Prefer RO |
| Prometheus | Workloads | Metrics | — | |
| Alerts | Operator channel | Notify | Token in Vault | No secrets in chat |
| AI agent | Host diagnostics | Status | Scoped | No cluster-admin until D8 |
