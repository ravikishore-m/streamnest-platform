# Media Streaming Platform

Enterprise-style self-hosted streaming platform on TrueNAS + k3s (Terraform, Ansible, Helm, Argo CD, Vault, GitHub Actions / GHCR).

**Phase:** Architecture + **parallel** Kubernetes app charts for Jellyfin and the streaming stack. Live TrueNAS Apps are untouched until staging proof and cutover approval.

## Strict git rule

Commits must **not** list Cursor or any AI agent as `Co-authored-by`. See `CONTRIBUTING.md`.

## Decisions

[`docs/architecture/decisions.md`](docs/architecture/decisions.md) · [`docs/PROJECT_STATUS.md`](docs/PROJECT_STATUS.md)

## Parallel app track

| Chart | Role |
|-------|------|
| `charts/jellyfin` | Official Jellyfin image by digest; staging software encode |
| `charts/seerr` | Requests |
| `charts/sonarr` / `radarr` / `prowlarr` / `bazarr` | *arr |
| `charts/qbittorrent` | Downloads client |
| `charts/navidrome` | Music |
| `charts/platform-smoke` | Custom GHCR promotion proof |

GitOps: `apps/staging/applications/*`, `apps/production/applications/*` (manual sync until gates pass).

## Related live systems

- TrueNAS Apps Jellyfin (QSV) — production traffic today  
- OpenACP Telegram agent on WD SSD  
- Existing tooling: `~/truenas-arr`  

## Do not

- Apply Terraform without Phase 3 approval  
- Point staging at live Jellyfin config paths  
- Cut over clients until staging acceptance is signed off  
