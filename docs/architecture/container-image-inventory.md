# Container image inventory

This inventory records the image sourcing policy for the single Kubernetes
environment. A tag is not a release approval: deployable values must include
the tested immutable digest after the image has passed the scan gate.

| Workload | Source class | Image source | Git build? | Current evidence state |
|---|---|---|---:|---|
| Jellyfin | Official upstream | `ghcr.io/jellyfin/jellyfin` | No | Version and digest must be verified before enablement |
| Sonarr | Verified community | `ghcr.io/home-operations/sonarr` | No | Existing chart value has a digest; re-scan before use |
| Radarr | Verified community | `ghcr.io/home-operations/radarr` | No | Existing chart value has a digest; re-scan before use |
| Prowlarr | Verified community | `ghcr.io/home-operations/prowlarr` | No | Digest still required before enablement |
| Bazarr | Verified community | `ghcr.io/home-operations/bazarr` | No | Digest still required before enablement |
| qBittorrent | Verified community | `ghcr.io/home-operations/qbittorrent` | No | Existing chart value has a digest; re-scan before use |
| Seerr | Verified community | `ghcr.io/seerr-team/seerr` | No | Existing chart value has a digest; re-scan before use |
| Platform smoke | Custom project image | `ghcr.io/<owner>/streamnest-platform-smoke` | Yes | CI builds, scans, and publishes the image |
| Argo CD | Official upstream install | Pinned Argo CD release manifest | No | Version pinned in Ansible bootstrap |
| cert-manager | Official CNCF project chart | `cert-manager` from Jetstack | No | Chart version pinned in Argo Application |
| Vault | Official HashiCorp chart/image | `vault` from HashiCorp | No | Chart version pinned in Argo Application |

The live TrueNAS Apps are not rebuilt or relabeled by this repository. The
parallel Kubernetes workloads run as OCI containers inside the dedicated
Linux VM. Native TrueNAS App catalog duplication would create a second
control plane and is intentionally not used.

CI must retain the image digest, SBOM, vulnerability result, provenance, and
promotion evidence with the release record. No mutable `latest` tag is a
production approval.
