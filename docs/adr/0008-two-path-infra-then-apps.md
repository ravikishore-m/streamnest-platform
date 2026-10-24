# ADR 0008 — Two paths: infra then apps

## Status

Accepted (2026-10-24)

## Context

ADR 0002 assigns Terraform, Ansible, and Helm/Argo ownership, but day-to-day work mixed cluster bootstrap, edge proxy, seeds, and app image CI in one mental model. That raised blast radius and made progress feel heavier than necessary.

## Decision

Treat the platform as **two sequential paths**:

1. **Path 1 — Infra provisioning** (first): Terraform → Ansible → platform bootstrap (Argo project/RBAC) → cert-manager/Vault platform services.
2. **Path 2 — Application deployment** (only after Path 1 exit criteria): Helm charts, Argo Applications, GHCR builds, optional one-way NAS→PVC seeds.

### Exit criteria (Path 1 → Path 2)

- k3s reachable  
- Argo CD installed  
- AppProject `streamnest` applied  
- cert-manager and Vault platform Applications healthy

### Working rules

- One PR = one path.  
- Infra PRs never bump app image digests or seed PVCs.  
- Apps PRs never change Terraform/Ansible or guest networking.  
- Extends ADR 0002; does not replace tool ownership.

## Consequences

- Clearer review surfaces and CI blast radius (`infra.yml` vs `apps.yml`).  
- Temporary parallel TrueNAS Apps remain Path 2 concerns (seeds/cutover), not Path 1.  
- A local OCI registry remains a separately reviewed platform component; GHCR is
  the current CI registry until a private-runner/network path is proven.

## Security

No automatic `terraform apply` from app PRs. Secrets stay SOPS-encrypted; site inventory stays out of Git (D12).
