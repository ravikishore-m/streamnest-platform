# ADR 0003 — Parallel Jellyfin on k8s; host acceleration until cutover

## Status

Accepted; amended for single-env and privacy (D12)

## Context

Live Jellyfin on NAS Apps has working host iGPU acceleration. A parallel k8s deploy is required without sharing live config paths.

## Decision

1. Keep live Jellyfin on NAS Apps until acceptance + explicit cutover.  
2. Deploy Jellyfin on the single k8s cluster using the official upstream image by digest.  
3. k8s transcoding starts **software-only**; GPU/iGPU passthrough deferred.  
4. Media stays on the media pool; mount via NFS (or equivalent) with site paths only in local config — prefer read-only.  
5. Separate config/cache PVCs — never bind-mount live NAS app config into k8s.  

## Consequences

Two instances may exist during validation (NAS + k8s) with distinct endpoints. Cutover is a client/DNS switch, not an in-place edit of the live App.

## Security

Separate secrets. Validation controls are least privilege and read-only media
where practical. No site inventory in Git.
