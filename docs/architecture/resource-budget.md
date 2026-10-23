# Resource budget

Values from Phase 0 discovery (2026-10-23). Treat as planning limits until measured under dual-VM load.

## Host RAM (31 GiB)

| Consumer | Reserve (GiB) | Notes |
|----------|---------------|-------|
| ZFS ARC | 8 | POSTINIT cap |
| Live Jellyfin | 4 | App limit |
| *arr / Seerr / qBit / misc Apps | 4 | Ballpark RSS |
| OpenACP | 1 | |
| Host obs-lite / Netdata | 2 | Until moved to k8s |
| TrueNAS OS / middleware | 3 | |
| **k3s-prod VM** | **8** | Always-on target |
| **k3s-staging VM** | **0 or 4–6** | **0 when idle-off** |
| Headroom | ≥ 1–2 | Abort staging start if free RAM low |

When staging is **on**, expect tight headroom — avoid concurrent heavy Immich/Nextcloud (already STOPPED).

## CPU

| Consumer | Guidance |
|----------|----------|
| Live Jellyfin | 6 CPUs reserved (App) |
| k3s-prod | 6 vCPU HOST-PASSTHROUGH |
| k3s-staging | 4 vCPU |
| Host | Prefer not pinning all P-cores to VMs |

## WD SSD

| Use | Cap |
|-----|-----|
| Existing ix-apps + configs + openacp | As-is (~32 GiB used) |
| Prod + staging VM disks | ~144–164 GiB volsize total |
| k8s PV datasets | Quotas ≤ 250 GiB combined |
| Free floor | Keep ≥ 200 GiB unallocated contingency |

## Toshiba backup

Nearly empty 1 TB HDD — dedicate to replication/backup datasets only; no media primary.
