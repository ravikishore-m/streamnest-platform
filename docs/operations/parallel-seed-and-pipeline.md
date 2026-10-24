# Path 2 — Seeds and app CI

**Path 2 only.** Complete [Path 1 — Infra](infra-path.md) before using this. See ADR 0008 / D14.

## Rule

**Live TrueNAS Apps are read-only sources.** Streamnest k8s apps get a **one-way replica** into `streamnest-seeds/`, then into PVCs. Nothing writes back to live `configs/<app>` trees used by ix-* containers.

## Workflow: `.github/workflows/apps.yml`

| Job | Runner | When |
|-----|--------|------|
| `helm` / `secrets-hygiene` | `ubuntu-latest` | push/PR touching app paths |
| `build-push` | `ubuntu-latest` → **GHCR** | push `main` / dispatch |
Infra CI is separate: `.github/workflows/infra.yml` (Terraform; no Docker build).

### Official actions (apps)

| Step | Action |
|------|--------|
| Checkout | `actions/checkout` |
| Helm | `azure/setup-helm` |
| Registry login | `docker/login-action` (GHCR + `GITHUB_TOKEN`) |
| Buildx | `docker/setup-buildx-action` |
| Tags | `docker/metadata-action` |
| Build + push | `docker/build-push-action` |

Custom image: `ghcr.io/<owner>/streamnest-platform-smoke` (public package or cluster pull secret).

## Seed flow (deferred and controlled)

The seed copy is intentionally not an operational shell script. When enabled,
it must be implemented as a reviewed Kubernetes Job or Ansible task with a
read-only source mount, an explicit allowlist of source directories, checksum
evidence, a bounded destination, and a dry-run/restore test. It must never
write to the live TrueNAS Apps configuration tree and must never copy cache or
runtime databases without an approved application-specific procedure.

Until that Job or playbook is reviewed and tested, applications start with
empty dedicated PVCs. This document does not claim that live configuration has
been migrated.

## Secrets

Plaintext gitignored; tracked `secrets/*.enc.yaml` (SOPS) — see `secrets/README.md`.

## Operator-only inputs

Any source path, export, hostname, token, or kubeconfig belongs in ignored
local inventory or the approved secret store. Do not add NAS paths or private
network values to workflow variables or repository documentation.
