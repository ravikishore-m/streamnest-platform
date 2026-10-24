# Architecture overview

## Physical

Single NAS host running TrueNAS with a dedicated Linux VM for k3s. **Not
physically highly available.** Hardware and addressing details are private.

## Logical

```mermaid
flowchart TB
  subgraph host [NAS_Host]
    LiveJF[Live_Jellyfin_App]
    LiveArr[Live_arr_stack]
    Media[(Media_Pool)]
    SSD[(Config_SSD_Pool)]
    Backup[(Backup_Pool)]
    subgraph vm [dedicated_Linux_VM]
      K3S[k3s_single_node]
      OCI[OCI_containers]
    end
  end

  subgraph gitops [Git_repo]
    Charts[charts]
    Apps[apps]
  end

  LiveJF --> Media
  LiveArr --> Media
  Apps --> K3S
  K3S --> OCI
  Charts --> Apps
  Backup -.->|planned_replication| SSD
```

## Parallel tracks

1. Platform: VM → k3s → Argo CD → Vault → observability  
2. Apps: Helm charts for Jellyfin and related services on the single cluster  

The existing TrueNAS Apps (including live Jellyfin) remain untouched during
parallel validation. k3s workloads are OCI containers running inside the
dedicated VM on the NAS; they are not duplicated as native TrueNAS Apps.
