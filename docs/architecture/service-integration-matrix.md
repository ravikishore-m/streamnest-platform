# Service integration matrix (sanitized)

Fill real hosts/ports only in `docs/private/service-integration-matrix.local.md` (gitignored).

| Source | Destination | Purpose | Auth | Notes |
|--------|-------------|---------|------|-------|
| Clients | Live Jellyfin (NAS Apps) | Playback | Jellyfin users | Via LAN or private VPN |
| Clients | k8s Jellyfin (future) | Validation | Separate users | After ingress |
| CI | GHCR | Image publish | OIDC/PAT | No prod secrets on fork PRs |
| Argo CD | Git | Desired state | Deploy key | |
| Argo CD | kube-apiserver | Apply | RBAC SA | |
| Apps | Vault | Secrets | K8s auth | Later |
| Jellyfin k8s | NFS media | Read media | Export ACLs | Prefer RO |
| Prometheus | Workloads | Metrics | — | |
| Alerts | Operator channel | Notify | Token in Vault | No secrets in chat |
| AI agent | Host diagnostics | Status | Scoped | No cluster-admin until D8 |
