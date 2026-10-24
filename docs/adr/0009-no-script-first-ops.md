# ADR 0009 — No script-first operations

## Status

Accepted (2026-10-24)

## Context

Operational changes were often delivered as one-off NAS shell scripts (`scripts/*.sh`, ad-hoc `docker run`, qemu-guest-exec helpers). That bypassed Terraform/Ansible/GitOps ownership (ADR 0002) and mixed Path 1 / Path 2 work (ADR 0008).

## Decision

1. **Path 1** changes run via **Terraform** and **Ansible** only (playbooks/roles under `infrastructure/`).  
2. **Path 2** changes run via **Git + Argo CD** and **`apps.yml`** CI only.  
3. The `scripts/` directory is **deprecated**. No new operational scripts. Existing scripts may remain briefly as thin wrappers that call Ansible/CI, then be removed.  
4. Platform services are Kubernetes workloads reconciled by Argo CD. A local
   OCI registry is a separate approved platform component; it is not silently
   represented by `docker run` or Docker Compose.
5. Cluster access for operators is kubeconfig / `kubectl` / `argocd` CLI — not guest-agent wrappers as the normal path.  
6. Secrets are bootstrapped through the documented Kubernetes API path and
   then managed by Vault; plaintext `sops -d | kubectl` on a laptop is not the
   normal application path.

## Consequences

- Idempotent, reviewable infra and app changes.  
- Slightly more upfront Ansible/GitOps scaffolding.  
- Manual TrueNAS UI / first-boot exceptions still recorded privately (ADR 0007); import into Terraform/Ansible before claiming management.

## Security

Fewer opaque shell entrypoints; secrets stay encrypted in Git and decrypt only in the cluster CI/CMP path.
