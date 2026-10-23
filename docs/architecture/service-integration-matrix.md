# Service integration matrix

Skeleton from Phase 0 discovery. Connectivity tests marked **pending** until clusters exist.

| Source | Destination | Purpose | Identity / DNS | Proto / port | Auth | TLS | NetworkPolicy intent | Timeout / failure | Health | Status |
|--------|-------------|---------|----------------|--------------|------|-----|----------------------|-------------------|--------|--------|
| Clients (LAN/Tailscale) | Host Jellyfin | Live playback | `truenas-arr…:30013` / `192.168.68.56:30013` | HTTP 30013 | Jellyfin users | Optional | Host firewall / Tailscale ACLs | Client retry | JF UI | **Live** |
| Clients | Staging Jellyfin (future) | Validation | TBD MagicDNS/Ingress | 8096 via Ingress | Separate users | Desired | Deny cross-prod | Fail closed | Probes | Pending |
| GitHub Actions | GHCR | Push custom images | `ghcr.io/<org>/…` | HTTPS | CI token OIDC/PAT | Yes | Egress only | Job fail | Workflow | Pending remote |
| Argo CD | Git repo | Sync desired state | repo URL | HTTPS/SSH | Deploy key | Yes | Egress allow Git | Degraded sync | Argo health | Pending |
| Argo CD | kube-apiserver | Apply resources | in-cluster / external | 443 | SA RBAC | Yes | Control plane only | Sync fail | API ready | Pending |
| Apps | Vault | Secrets | vault.svc | 8200 | K8s auth | mTLS/TLS | Allow Vault only | App degrade | Vault seal/health | Pending |
| Jellyfin k8s | NFS/media | Read media | TrueNAS NFS export | 2049 | Export rules | Optional | Egress NFS to NAS IP | Playback fail | Mount probe | Pending |
| Jellyfin k8s | PVC config/cache | Persist metadata | storage class | — | — | — | — | Data loss risk | PVC bound | Pending |
| Prometheus | App metrics | Scrape | service endpoints | 9090 /metrics | None/bearer | Prefer | Scrape NS only | Stale metrics | Prom targets | Partial (host obs-lite) |
| Grafana | Prometheus | Dashboards | prom SVC | 9090 | SSO later | Yes | — | Empty panels | Grafana | Partial (host) |
| Alertmanager / hooks | Telegram via OpenACP | Notify | allowlisted API | HTTPS/local | Token (Vault) | Yes | Egress Telegram only | Drop alert | Ack | Deferred (D8) |
| OpenACP | Host diagnostics | Status | local scripts | — | OS user | — | **No cluster-admin until D8** | — | Watchdog | Live (host) |
| Tailscale | Host services | Remote access | `100.107.194.4` | various | Tailscale identity | WireGuard | Tailnet ACL | Unreachable | `tailscale status` | Live interface |

## Notes

- Do not expose Vault, kube-apiserver, or Argo CD publicly.  
- Staging must not mount production Jellyfin config paths.  
- Matrix rows marked Pending require a real connectivity test before claiming “integrated.”
