# Project status

**Phase:** 1 — Architecture + parallel app scaffolding (in progress → awaiting Phase 3 provision approval)  
**Updated:** 2026-10-23  
**Host:** TrueNAS `26.0.0-BETA.3` @ `192.168.68.56`  
**Authorship rule:** **No Cursor/AI `Co-authored-by` on commits** (D10 — strict)

## Locked decisions

See [`docs/architecture/decisions.md`](architecture/decisions.md).

Highlights: Topology **A** (dual VMs, staging idle-off); live Jellyfin stays on Apps; k8s staging Jellyfin = software encode; proceed on BETA; Toshiba backup target; **parallel k8s apps** for Jellyfin + stack; OpenACP hardening deferred.

## What exists now (repo)

| Area | Status |
|------|--------|
| Phase 0 discovery | Done |
| ADRs 0001–0005 | Done |
| Helm charts: jellyfin, seerr, sonarr, radarr, prowlarr, bazarr, qbittorrent, navidrome, platform-smoke | Scaffolded (not deployed) |
| `apps/staging` + `apps/production` Argo Applications | Declared, manual sync |
| `services/platform-smoke` Dockerfile | Ready to build when GHCR org set |
| Terraform staging/prod env sketches | Validate-only; **no apply** |
| Live NAS / Jellyfin / OpenACP | **Unchanged** |

## Not done / not claimed working

- No k3s cluster running for these apps  
- No NFS export for staging media  
- No Argo CD installed  
- No GHCR push  
- No Terraform apply  
- Digests for prowlarr/bazarr/navidrome still need verification where marked  

## Next approval gate (Phase 3)

1. Confirm Topology A sizes (staging 4 GiB / prod 8 GiB).  
2. Create TrueNAS API key for Terraform (you create; not committed).  
3. Approve dataset/zvol **create** on WD SSD + Toshiba backup datasets.  
4. Approve git remote host if not already pushed.  
5. Rotate legacy k3s cloud-init password before any VM start.

Phase 2 (CI workflows, LICENSE, SECURITY.md hardening) can proceed without live provision.

## Resume

Read this file → `docs/architecture/decisions.md` → ADRs. Do not re-discover NAS unless facts changed.
