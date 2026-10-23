# Streamnest Platform

Self-hosted streaming platform on TrueNAS + **single-env** k3s.

## Privacy (strict)

Do **not** commit:

- Personal names, emails, Telegram IDs, or account handles beyond the public Git remote  
- LAN/VPN IPs, MagicDNS names, SSH aliases, or usernames  
- Pool/dataset/zvol paths, disk serials, or media library details  
- API keys, kubeconfigs, `secrets.yaml`, or Terraform state  

Use `config/local.example.yaml` → `config/local.yaml` (gitignored) and `docs/private/` for site data.

## Decisions

See `docs/architecture/decisions.md` and `docs/PROJECT_STATUS.md`.

- One k3s environment (`streamnest`)  
- Live Jellyfin stays on NAS Apps until cutover  
- No AI/agent commit co-authors  

## Layout

```text
apps/             # Argo Applications + values (no plaintext secrets)
charts/           # jellyfin, seerr, *arr, platform-smoke
platform/argocd/  # AppProject + RBAC + server params
secrets/          # SOPS-encrypted *.enc.yaml only
config/           # local.example.yaml only; local.yaml ignored
infrastructure/   # terraform + ansible (placeholders)
services/         # custom images (e.g. platform-smoke)
scripts/          # seed (read-only from live NAS Apps), CI deploy, SOPS apply
docs/             # public ADRs/architecture (sanitized)
```

## Pipeline

GitHub Actions `pipeline` (self-hosted `streamnest` runner): validate → build/push custom images → Argo refresh.  
One-way config seed from live TrueNAS Apps is optional (`replicate_seeds` / `apply_seeds`) and **never writes** the original ix-* configs. See `docs/operations/parallel-seed-and-pipeline.md`.
