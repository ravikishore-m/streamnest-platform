# Project status

**Phase:** 2 (repo/CI) + Phase 3 partial (single-env VM; networking follow-up)  
**Authorship:** no AI/agent `Co-authored-by` on commits  

## Topology

**Single environment** — one k3s VM/cluster (`streamnest`). No staging/prod split (ADR 0006).

Live Jellyfin remains on the NAS app layer until an explicit cutover.

## In Git (safe)

- Helm charts and Argo app manifests with **placeholder** endpoints  
- ADRs and architecture (no site inventory)  
- Terraform/Ansible **shapes** with placeholders  
- CI validate workflow  

## Not in Git (private)

- Hostnames, LAN/Tailscale IPs, MagicDNS  
- Pool/dataset/zvol paths, disk models/serials  
- SSH users/aliases, API keys, kubeconfigs, `secrets.yaml`  
- Media library sizes and personal paths  
- Agent/Telegram configuration  

Use `config/local.yaml` (from `config/local.example.yaml`) and `docs/private/`.

## Blocker

Guest VM inbound LAN access needs a host **bridge** (or Tailscale in-guest). Details in private runbook notes — public steps: `docs/operations/runbooks/streamnest-bridge-networking.md`.

## Next

1. Keep secrets and inventory out of Git.  
2. Finish cluster admin access (bridge or Tailscale).  
3. Verify `kubectl get nodes`, then Argo CD.
