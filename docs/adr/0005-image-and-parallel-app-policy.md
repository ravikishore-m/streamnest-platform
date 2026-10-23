# ADR 0005 — Image sourcing and parallel app promotion

## Status

Accepted (2026-10-23)

## Context

Multiple TrueNAS Apps already pin digests for Jellyfin and *arr images. Some custom apps use mutable `:latest`. Platform requires GHCR for custom images and digest promotion staging → prod.

## Decision

1. Prefer **official upstream** images (Jellyfin, Prometheus, Grafana, Vault, Argo CD).  
2. Prefer **verified community** images already in use (`ghcr.io/home-operations/*`, Seerr) after digest pin + scan.  
3. Build **custom** images only for project-owned code (e.g. `platform-smoke`) → GHCR.  
4. **One digest** validated in staging is promoted to production — never rebuild for prod.  
5. Ban mutable `latest` in staging/prod values files.  
6. Parallel k8s apps are declared under `apps/staging/` and `apps/production/`; production Applications stay sync-manual or unavailable until gates pass.

## Consequences

- Chart values carry `tag` + `digest`.  
- CI must record SBOM/scan evidence before staging sync.  

## Security

Image pull secrets least-privilege; Cosign verification where feasible in later phases.
