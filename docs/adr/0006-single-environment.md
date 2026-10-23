# ADR 0006 — Single Kubernetes environment

## Status

Accepted. Supersedes dual-VM staging/prod (ADR 0001).

## Context

Operator chose one environment to reduce RAM/ops cost.

## Decision

One Linux VM + one single-node k3s cluster. GitOps under `apps/`. Terraform under `environments/streamnest/`. Reintroduce a second env only via a new ADR.

## Consequences

No dual-env promotion; use digest pinning, manual Argo sync, and keep NAS Apps as production streaming until cutover. Site IPs/hostnames stay out of Git (D12).
