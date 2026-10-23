# ADR 0004 — WD SSD budget and Toshiba backup destination

## Status

Accepted (2026-10-23)

## Context

WD Black SN850X pool has ~867 GiB free and already holds ix-apps, configs, OpenACP, and a 64G k3s zvol. No independent backup destination existed (no replication/cloudsync/periodic snapshots). Toshiba_HDD_1TB is nearly empty.

## Decision

### WD SSD allocation (design — create in Phase 3 after approval)

| Dataset / zvol | Purpose | Quota guidance |
|----------------|---------|----------------|
| `WD_Black_1TB_SSD/vms/k3s-prod-disk` | Prod VM disk | 80–100 GiB volsize |
| `WD_Black_1TB_SSD/vms/k3s-staging-disk` | Staging VM disk | 64 GiB volsize |
| `WD_Black_1TB_SSD/k8s/staging` | Staging PV backends / exports as needed | Quota ≤ 100 GiB |
| `WD_Black_1TB_SSD/k8s/production` | Prod PV backends | Quota ≤ 150 GiB |
| Existing `configs/`, `ix-apps/`, `openacp/` | Unchanged until cutovers | Do not delete |

Do not give Kubernetes the entire SSD. Cap observability retention on cluster disks.

### Backup

- **Primary independent target:** `Toshiba_HDD_1TB` for replicated/copied configs, Terraform state exports, Vault snapshots, and Jellyfin metadata backups.  
- Enable **periodic ZFS snapshots** on critical WD datasets (configs, k8s datasets) with retention policy.  
- Snapshots alone are not DR; verify Toshiba receive/replication before claiming DR complete.  
- Cloud offsite: deferred.

## Consequences

- Clear capacity guardrails for Phase 3 provisioning.  
- Toshiba becomes critical; monitor health before relying on it.

## Security / recovery

Backup datasets restricted; no secrets in unencrypted world-readable shares. Test restore of Jellyfin config + a sample PVC before production cutover.
