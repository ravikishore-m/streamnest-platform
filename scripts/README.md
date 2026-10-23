# Scripts

| Script | Where | Purpose |
|--------|-------|---------|
| `replicate-nas-seeds.sh` | NAS | One-way live TrueNAS Apps configs → `streamnest-seeds/` (never writes live) |
| `apply-seeds-to-k8s.sh` | NAS + kubectl | Seed NFS → k8s PVCs |
| `apply-sops-secrets.sh` | ops machine | Decrypt SOPS → regcred + Argo admin hash |
| `ci-build-push-deploy.sh` | NAS fallback | Argo refresh (+ optional seeds); CI is `.github/workflows/ci.yml` on `ubuntu-latest` → GHCR |
| `nas-build-platform-smoke.sh` | NAS | Smoke image only |

Site paths/IPs via env or `config/local.yaml` — not committed.
