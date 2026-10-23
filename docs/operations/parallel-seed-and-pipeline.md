# Parallel seed + GitOps pipeline

## Rule

**Live TrueNAS Apps are read-only sources.** Streamnest k8s apps get a **one-way replica** into `streamnest-seeds/`, then into PVCs. Nothing writes back to `configs/sonarr` (etc.) used by ix-* containers.

## Single workflow: `.github/workflows/ci.yml`

| Job | Runner | When |
|-----|--------|------|
| `helm` / `terraform` / `secrets-hygiene` | `ubuntu-latest` (instant) | every push/PR |
| `build-push` | `ubuntu-latest` → **GHCR** | push `main` / dispatch |
| `argo-refresh` | self-hosted `streamnest` (optional) | after build; `continue-on-error` |
| `nas-seeds` | self-hosted `streamnest` | dispatch flags only |

### Official actions

| Step | Action |
|------|--------|
| Checkout | `actions/checkout` |
| Helm | `azure/setup-helm` |
| Terraform | `hashicorp/setup-terraform` |
| Registry login | `docker/login-action` (GHCR + `GITHUB_TOKEN`) |
| Buildx | `docker/setup-buildx-action` |
| Tags | `docker/metadata-action` |
| Build + push | `docker/build-push-action` (GHA cache) |
| kubectl (NAS jobs) | `azure/setup-kubectl` |

Custom image: `ghcr.io/<owner>/streamnest-platform-smoke` (package must be public or the cluster needs a GHCR pull secret).

## Seed flow (NAS)

1. `scripts/replicate-nas-seeds.sh` — live → seeds  
2. Pack `*.tgz`, HTTP serve; `scripts/apply-seeds-to-k8s.sh` → config PVCs  

## Secrets in Git

- Plaintext gitignored; tracked `secrets/*.enc.yaml` (SOPS) — see `secrets/README.md`

## Argo admin roles

`platform/argocd/` — AppProject `streamnest`, RBAC groups, `/argocd` base path.

## Optional GitHub Actions secrets (NAS jobs only)

| Secret | Purpose |
|--------|---------|
| `STREAMNEST_NAS_CONFIG_ROOT` | live configs parent |
| `STREAMNEST_NAS_SEED_ROOT` | seed parent |
| `STREAMNEST_SEED_HTTP_BASE` | seed tarball HTTP base |
| `STREAMNEST_KUBECTL` | optional kubectl wrapper |
