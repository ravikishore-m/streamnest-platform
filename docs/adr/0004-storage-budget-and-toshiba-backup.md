# ADR 0004 — SSD budget and separate backup destination

## Status

Accepted; sanitized (pool names private — D12)

## Context

App/VM data should live on fast SSD-backed storage. Media stays on the bulk media pool. An independent backup destination is required (snapshots alone are not DR).

## Decision

1. Allocate SSD capacity with **quotas** for VM disks and k8s PVCs; keep contingency free space.  
2. Do not put the media library in container images or on the OS boot device.  
3. Use a **separate backup pool/disk** for config/metadata/state backups (exact dataset names in `config/local.yaml` / private docs only).  
4. Enable periodic snapshots on critical datasets; verify restore before cutover.

## Consequences

Clear guardrails without publishing site topology. Operators must not commit real pool paths.
