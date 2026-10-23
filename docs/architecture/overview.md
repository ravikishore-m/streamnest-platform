# Architecture overview

## Physical

Single TrueNAS host (i9-12900K, 31 GiB RAM, Skyhawk media, WD SSD apps/VMs, Toshiba backups). **Not physically highly available.**

## Logical (approved Topology A)

```mermaid
flowchart TB
  subgraph host [TrueNAS_BETA]
    LiveJF[Live_Jellyfin_App_QSV]
    LiveArr[Live_arr_Seerr_stack]
    OACP[OpenACP]
    Media[(Skyhawk_Media)]
    SSD[(WD_SSD)]
    Toshiba[(Toshiba_Backup)]
    subgraph vms [Linux_VMs]
      ProdVM[k3s-prod]
      StageVM[k3s-staging_idle_off]
    end
  end

  subgraph gitops [Git_this_repo]
    Charts[charts_jellyfin_and_stack]
    AppsS[apps_staging]
    AppsP[apps_production]
  end

  LiveJF --> Media
  LiveArr --> Media
  StageVM -->|parallel_staging_apps| Charts
  ProdVM -->|after_gates| Charts
  AppsS --> StageVM
  AppsP --> ProdVM
  SSD --> vms
  Toshiba -.->|replication_planned| SSD
```

## Parallel tracks

1. **Platform:** Terraform VMs → Ansible k3s → Argo CD → Vault → observability.  
2. **Apps:** Helm charts + staging Argo Applications for Jellyfin, Seerr, *arr, qBittorrent, Navidrome, platform-smoke — developed now; reconcile when staging cluster is up.

Live Apps keep serving clients until cutover approval.
