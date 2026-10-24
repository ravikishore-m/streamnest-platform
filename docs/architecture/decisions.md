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
| D10 | Git authorship | No AI/agent commit co-authors |
| D11 | Env count | Single env only |
| D12 | Privacy | No personal or site-internal inventory in Git |
| D13 | CI runners | GitHub-hosted `ubuntu-latest`; custom images → GHCR; separate `infra.yml` / `apps.yml` |
| D14 | Delivery paths | **Infra first, then apps** — two separate tracks; one PR = one path. ADR 0008. |
| D15 | Ops tooling | **No script-first ops** — Terraform/Ansible (Path 1), Git+Argo+`apps.yml` (Path 2). ADR 0009. |

## Tracks

- **Path 1 (infra):** `infrastructure/` (Terraform + Ansible), `platform/argocd/` for Argo, cert-manager, and Vault.
- **Path 2 (apps):** `charts/`, `apps/`, `services/`, GitOps secrets + optional seed Job.
- Site-specific NFS/IPs only in gitignored local values. `scripts/` deprecated.
