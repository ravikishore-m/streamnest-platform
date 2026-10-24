# Path 1 — Infrastructure provisioning

Complete this path before any Path 2 (apps) work. See ADR 0008 / D14 / ADR 0009.

**Primary interface:** Terraform + Ansible. Not ad-hoc NAS shell scripts.

## Order

```bash
# 0) One-time: create the versioned, locked TrueNAS S3 state bucket.
#    See docs/operations/terraform-state-backend.md; do not put credentials in Git.

# 1) Terraform: NAS VM, zvol, platform dataset, and snapshot policy.
cd infrastructure/terraform/environments/streamnest
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars -out=streamnest.tfplan
terraform apply streamnest.tfplan

# 2) Ansible: guest baseline and k3s.
cd ../../../../infrastructure/ansible
ansible-galaxy collection install -r collections/requirements.yml
ansible-playbook -i inventories/streamnest/hosts.local.yml playbooks/k3s-server.yml

# 3) Ansible + Kubernetes API: pinned Argo CD bootstrap and platform apps.
ansible-playbook -i inventories/streamnest/hosts.local.yml \
  playbooks/platform-bootstrap.yml \
  -e streamnest_repo_local_path=/path/to/Media_Streaming_Platform
```

Terraform applies only supported TrueNAS infrastructure. Ansible configures
the Linux guest and uses `kubernetes.core` against the k3s API for the pinned
Argo CD bootstrap. Vault and cert-manager are then reconciled by Argo CD from
the reviewed manifests under `platform/argocd/`. The k3s release is pinned in
the playbook and must be changed only after compatibility testing.

## Exit criteria

- k3s API reachable (kubeconfig from Ansible fetch / guest)  
- Argo CD installed; `platform/argocd` applied  
- AppProject `streamnest` present  
- Argo CD, cert-manager and Vault Applications are present and healthy
- Cluster access is available through a private operator path

## Working rules

- Infra PRs never bump app image digests or seed PVCs.  
- Do not use `kubectl apply` as the normal **app** path after GitOps exists (ADR 0002).  
- No automatic live `terraform apply` from PRs.
- Never run `terraform destroy` as routine automation.
- No new operational scripts (ADR 0009).
