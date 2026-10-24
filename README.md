# Streamnest Platform

Self-hosted streaming platform on TrueNAS + **single-env** k3s.

## Two paths (do infra first)

```text
Path 1 — Infra provisioning          Path 2 — Application deployment
─────────────────────────────         ───────────────────────────────
Terraform (NAS / VM / storage)   →    Helm charts + Argo Applications
Ansible (guest OS / k3s)         →    GHCR build + values pin
Argo / edge bootstrap            →    Optional one-way NAS→PVC seeds
```

**Exit Path 1** (k3s up, Argo installed, `streamnest` AppProject, cert-manager and Vault healthy) **before** Path 2 work.
One PR = one path. See [ADR 0008](docs/adr/0008-two-path-infra-then-apps.md) and [decisions](docs/architecture/decisions.md).

### Path 1 — Infra

| Area | Location |
|------|----------|
| NAS / VM / storage | `infrastructure/terraform/` |
| Guest OS / k3s | `infrastructure/ansible/` |
| Argo project / RBAC | `platform/argocd/` |
| Ops order | `docs/operations/infra-path.md` |

### Path 2 — Apps

| Area | Location |
|------|----------|
| Charts + Application CRs | `charts/`, `apps/` |
| Custom images | `services/` |
| Encrypted secrets | `secrets/*.enc.yaml` |
| Seeds / app CI notes | `docs/operations/parallel-seed-and-pipeline.md` |

## Privacy (strict)

Do **not** commit personal identifiers, LAN/VPN inventory, pool paths, or plaintext secrets.
Use `config/local.example.yaml` → `config/local.yaml` (gitignored) and `docs/private/` for site data.

## CI

- **`infra.yml`** — Terraform validate + secrets hygiene (infra paths only).
- **`apps.yml`** — Helm lint, GHCR build/push, values pin (app paths only).
- **`floci-contract.yml`** — disposable AWS API compatibility checks only.

Live Jellyfin stays on NAS Apps until explicit cutover (D2). No AI/agent commit co-authors (D10).
## Floci boundary

Floci is used in GitHub Actions as a disposable AWS API emulator for contract
tests. It does not host production services. The real platform remains
TrueNAS + Linux VM + k3s + Terraform + Ansible + Argo CD + Vault; see
[`docs/architecture/floci-validation.md`](docs/architecture/floci-validation.md).
