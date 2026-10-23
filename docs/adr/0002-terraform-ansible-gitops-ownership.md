# ADR 0002 — Terraform, Ansible, and GitOps ownership

## Status

Accepted (2026-10-23)

## Context

TrueNAS 26.0 exposes VM/dataset APIs; official Terraform provider `truenas/truenas` supports 25.10+. Guest OS and k3s need configuration management. Applications must reconcile from Git.

## Decision

| Layer | Tool | Owns |
|-------|------|------|
| NAS infrastructure | Terraform (`infrastructure/terraform/`) | Datasets, zvols, VMs, NICs, snapshot/replication tasks where supported |
| Linux guests | Ansible (`infrastructure/ansible/`) | OS baseline, packages, k3s install/join, hardeners, allowlisted remediation |
| Kubernetes apps | Helm + Argo CD (`charts/`, `apps/`, `platform/`) | Workloads, config (non-secret), progressive delivery |

Do not let Terraform and Ansible manage the same resource. Do not use `kubectl apply` as the normal production path after GitOps exists.

## Consequences

- Clear blast radius and review surfaces.  
- Terraform state may contain secrets — remote state + encryption required before apply.  
- Provider gaps on BETA must be ADRed; never pretend manual objects are Terraform-managed.

## Security

API keys and state backends outside Git. No automatic production `terraform apply` from PRs. No routine `terraform destroy` in CI.

## Recovery

State backup/restore runbook; Ansible check-mode for guest drift; Argo CD app recreate from Git.
