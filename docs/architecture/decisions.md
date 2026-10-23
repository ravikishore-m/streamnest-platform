# Approved decisions

| ID | Decision | Locked choice |
|----|----------|---------------|
| D1 | Topology | **Single env** — one k3s VM/cluster. ADR 0006. |
| D2 | Live Jellyfin | Stay on NAS Apps until k8s acceptance + explicit cutover |
| D3 | Transcoding | Host iGPU for live Jellyfin; software-only on k8s until passthrough tested |
| D4 | NAS OS train | Proceed on current installed TrueNAS release (incl. beta risk if applicable) |
| D5 | Backup | Separate backup pool/disk from primary media (names private) |
| D6 | Git remote | Public GitHub repo; plaintext secrets forbidden — SOPS `secrets/*.enc.yaml` only |
| D7 | Scope | Platform + parallel k8s charts for Jellyfin and streaming stack |
| D8 | AI agent hardening | Deferred |
| D9 | VM credentials | Rotate; store only in local secrets |
| D10 | Git authorship | No AI/agent co-authors |
| D11 | Env count | Single env only |
| D12 | Privacy | No personal or site-internal inventory in Git |

## App track

Charts under `charts/`; GitOps under `apps/`. Site-specific NFS/IPs only in gitignored local values.
