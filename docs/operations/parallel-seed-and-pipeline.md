# Parallel seed + GitOps pipeline

## Rule

**Live TrueNAS Apps are read-only sources.** Streamnest k8s apps get a **one-way replica** into `streamnest-seeds/`, then into PVCs. Nothing writes back to `configs/sonarr` (etc.) used by ix-* containers.

## Flow

1. `scripts/replicate-nas-seeds.sh` — `rsync` live → seeds (excludes cache/transcodes/logs)  
2. Pack seeds to `*.tgz`, serve briefly over HTTP on the NAS; `scripts/apply-seeds-to-k8s.sh` Jobs `wget` into the **config** PVC and set path URL bases on the **copy only**  
3. Argo CD syncs charts/values from Git  
4. CI `pipeline` / `scripts/ci-build-push-deploy.sh` — build custom images → push registry → hard-refresh Applications  

## Secrets in Git

- Plaintext `secrets.yaml` stays **gitignored**  
- Tracked: `secrets/*.enc.yaml` (SOPS + age) — see `secrets/README.md`  
- Apply: `scripts/apply-sops-secrets.sh` (regcred + Argo admin bcrypt)  

## Argo admin roles

Declarative under `platform/argocd/`:

- `AppProject` `streamnest` with `admin` / `readonly` roles  
- `argocd-rbac-cm` groups: `streamnest-admins`, `streamnest-ops`, `streamnest-readonly`  
- Path base `/argocd` via `argocd-cmd-params-cm`  

Bootstrap once: `kubectl apply -f platform/argocd/` then sync `argocd-config`.

## GitHub Actions secrets (self-hosted `streamnest` runner)

| Secret | Purpose |
|--------|---------|
| `STREAMNEST_REGISTRY` | `host:port` |
| `STREAMNEST_REGISTRY_USER` | robot user |
| `STREAMNEST_REGISTRY_PASSWORD` | robot password |
| `STREAMNEST_NAS_CONFIG_ROOT` | live configs parent |
| `STREAMNEST_NAS_SEED_ROOT` | seed parent |
| `STREAMNEST_NAS_NFS_SERVER` | NAS IP/DNS for guest NFS |
| `STREAMNEST_KUBECTL` | optional kubectl wrapper |

Workflow dispatch flags: `replicate_seeds`, `apply_seeds`.
