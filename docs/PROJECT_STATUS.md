# Project status

**Phase:** 3 bootstrap complete (single-env k3s + Argo CD); inbound LAN access still via workarounds  
**Authorship:** no AI/agent `Co-authored-by` on commits  

## Topology

**Single environment** — one k3s VM/cluster (`streamnest`). No staging/prod split (ADR 0006).

Live Jellyfin remains on the NAS app layer until an explicit cutover.

## Done

- Single-env GitOps layout (`apps/`, charts, Terraform/Ansible shapes)
- Privacy hygiene (D12): inventory out of Git; `SECURITY.md` + CI secret checks
- `streamnest` VM running; k3s node **Ready**; qemu-guest-agent installed
- Argo CD installed (server-side apply); all core pods Running
- `streamnest-root` Synced/Healthy; `platform-smoke` Synced/Healthy (interim public image)
- Media apps registered but **not** synced (manual until acceptance)
- Guest admin path: virsh qemu-guest-agent from NAS (`/run/truenas_libvirt`)

## In Git (safe)

- Helm charts and Argo app manifests (repo URL set to public GitHub remote)
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

## Networking note

macvtap isolates guest from NAS host and blocks Mac→guest inbound. Guest egress to LAN/Internet works. Durable fix: TrueNAS **bridge** NIC (UI) or Tailscale-in-guest. Interim admin: guest-agent exec from NAS.

## Next

1. Durable cluster admin access (bridge or Tailscale).
2. Argo repo credentials if the GitHub remote is private; sync `streamnest-root`.
3. Sync `platform-smoke` first; keep media apps manual until acceptance.
4. Jellyfin cutover only after acceptance (NAS Apps stays live).
