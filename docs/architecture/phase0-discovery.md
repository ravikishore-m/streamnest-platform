# Phase 0 — Discovery summary (sanitized)

Site-specific inventory (hostnames, IPs, disk serials, pool names, Tailscale IDs, agent paths, and personal accounts) is **not stored in Git**.

Operators keep a private copy under `docs/private/` (gitignored) or offline notes.

## Public facts suitable for the repo

- Homelab NAS runs a current TrueNAS Community release with VM support.
- Streaming today uses TrueNAS Apps (Jellyfin + related services); k3s is introduced on a dedicated Linux VM.
- Hardware acceleration for live Jellyfin is via host iGPU; k8s Jellyfin starts software-encode only.
- Capacity planning and exact pool layouts live in private operator docs.
- Backup target is a separate pool/disk from primary media (details private).

## What was verified (categories only)

| Area | Result |
|------|--------|
| Virtualization | Supported; VM API available |
| Resources | Sufficient for a single k3s VM if sized conservatively |
| Jellyfin | Running as official container image on the NAS app layer |
| GitOps target | Single-env cluster (`streamnest`) |
| Secrets | Must never enter Git |

## Private checklist (do not commit answers)

- [ ] CPU/RAM/headroom measurements  
- [ ] Pool/dataset/zvol names and free space  
- [ ] LAN/Tailscale addresses and MagicDNS  
- [ ] SSH aliases and key paths  
- [ ] Agent/Telegram integration details  
