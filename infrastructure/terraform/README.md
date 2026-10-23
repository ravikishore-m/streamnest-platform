# Terraform — NAS infrastructure

Single environment: `environments/streamnest/`.

## Privacy

- Never commit API keys, state, plan files, or real pool/zvol/NIC names.  
- Use `*.tfvars` locally (gitignored) from `terraform.tfvars.example`.  
- First VM bring-up may be API/CLI; import before claiming Terraform management (ADR 0007).

## Offline check

```bash
cd environments/streamnest
terraform init -backend=false
terraform validate
```
