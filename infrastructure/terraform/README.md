# Terraform — TrueNAS infrastructure

Provider: [`truenas/truenas`](https://registry.terraform.io/providers/truenas/truenas) (TrueNAS 25.10+ / 26.0).

## Rules

- **No apply** until Phase 3 approval.
- Never auto-apply production from PRs.
- Never commit state, plans, or API keys.
- Rotate any cloud-init passwords before VM create/start (ADR D9).

## Layout

```text
environments/staging/   # k3s-staging VM + datasets (idle-off)
environments/production/# k3s-prod VM + datasets
modules/vm/             # reusable VM + zvol + nic sketch
```

## Offline validation

```bash
cd environments/staging
terraform init -backend=false
terraform validate
terraform fmt -check -recursive ../..
```

Live `terraform plan` requires `TRUENAS_API_KEY` + endpoint — create key manually on TrueNAS; do not store in Git.
