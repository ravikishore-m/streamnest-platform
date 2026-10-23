# ADR 0003 — Parallel Jellyfin on k8s; QSV stays on host until cutover

## Status

Accepted (2026-10-23); amended for parallel app track

## Context

Live Jellyfin on TrueNAS Apps has working Intel QSV via `/dev/dri`. Moving it into a VM/k8s without a tested device path risks streaming quality. Operator requires a **new parallel k8s app** for Jellyfin (and other stack apps) while live Apps continue.

## Decision

1. **Keep live Jellyfin** on TrueNAS Apps (host QSV) until staging k8s acceptance passes and cutover is explicitly approved.  
2. **Develop and deploy Jellyfin in staging k8s in parallel** using the official `ghcr.io/jellyfin/jellyfin` image by digest.  
3. **Staging k8s transcoding = software-only** initially. GPU/iGPU passthrough is deferred until tested.  
4. Media remains on Skyhawk; mount into staging via NFS (or equivalent) **read-only** where practical — do not copy the library into image layers.  
5. Staging uses **separate** config/cache PVCs on WD SSD-backed storage — never bind-mount live `/mnt/WD_Black_1TB_SSD/configs/jellyfin` into staging.  
6. Other eligible apps (Seerr, *arr, qBittorrent, Navidrome, …) get charts and staging GitOps apps in the same parallel track.

## Consequences

- Two Jellyfin instances may run during validation (host prod + k8s staging); use distinct ports/hostnames and do not share writable config.  
- Staging cannot claim QSV parity until passthrough is proven.  
- Cutover is a controlled switch of clients/DNS/Tailscale targets, not an in-place edit of the live App.

## Security

Separate secrets (Vault paths). Staging service accounts cannot write production datasets. Media mounts prefer RO.

## Recovery

Host App remains rollback path until cutover. After cutover, restore from PVC backups + GitOps revision; host App retained offline until confidence window ends.
