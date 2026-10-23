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
apps/             # Argo Applications + values (no secrets)
charts/           # jellyfin, seerr, *arr, navidrome, platform-smoke
config/           # local.example.yaml only; local.yaml ignored
infrastructure/   # terraform + ansible (placeholders)
services/         # custom images (e.g. platform-smoke)
docs/             # public ADRs/architecture (sanitized)
```
