# Resource budget (sanitized)

Exact measurements stay in `docs/private/`. Public guidance:

| Consumer | Guidance |
|----------|----------|
| ZFS ARC | Cap so apps/VMs keep headroom |
| Live Jellyfin | Keep existing app CPU/RAM limits |
| k3s VM (single) | Roughly mid-size guest (e.g. multi-vCPU / ~8 GiB class) — confirm privately |
| Observability | Bound retention; do not fill the SSD pool |
| Free RAM | Do not start heavy optional apps while validating the VM |

SSD pool: use quotas for VM disks and PVCs; keep unallocated contingency.  
Backup pool: dedicated; no primary media role.
