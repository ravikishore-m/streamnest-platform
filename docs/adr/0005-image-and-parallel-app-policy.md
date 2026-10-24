# ADR 0005 — Image sourcing and parallel app promotion

## Status

Accepted (2026-10-23)

## Context

The live TrueNAS Apps must remain untouched while the single Kubernetes
environment is validated. Platform requires GHCR for custom images and
immutable digest promotion within that one environment.

## Decision

1. Prefer **official upstream** images (Jellyfin, Prometheus, Grafana, Vault, Argo CD).  
2. Prefer **verified community** images already in use (`ghcr.io/home-operations/*`, Seerr) after digest pin + scan.  
3. Build **custom** images only for project-owned code (e.g. `platform-smoke`) → GHCR.  
4. The exact tested digest is promoted through the single environment — never
   rebuild for a later release target.
5. Ban mutable `latest` in all deployable values files.
6. Parallel Kubernetes applications are declared under `apps/`; the live NAS
   Apps remain the user-facing service until explicit cutover approval.

## Consequences

- Chart values carry `tag` + `digest`.  
- CI must record SBOM/scan evidence before Argo sync.

## Security

Image pull secrets least-privilege; Cosign verification where feasible in later phases.
