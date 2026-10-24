# Ansible — Path 1 guest and platform bootstrap

Owns the k3s guest baseline and the bounded Argo CD bootstrap. Terraform owns
the TrueNAS VM, zvol, datasets, and snapshot policy. Kubernetes applications
are reconciled by Argo CD after bootstrap.

## Inventory

| Group | Host example | Role |
|-------|--------------|------|
| `k3s` | `streamnest` | Guest OS + k3s + Argo |
Committed: `inventories/streamnest/hosts.yml` (placeholders).
Local: copy to `hosts.local.yml` + optional `group_vars/*.yml` from `*.yml.example` (gitignored).

```bash
cd infrastructure/ansible
cp inventories/streamnest/hosts.yml inventories/streamnest/hosts.local.yml
# edit hosts.local.yml — real IPs/users/keys only here
```

## Playbook order

```bash
ansible-galaxy collection install -r collections/requirements.yml
ansible-playbook -i inventories/streamnest/hosts.local.yml playbooks/k3s-server.yml
ansible-playbook -i inventories/streamnest/hosts.local.yml playbooks/platform-bootstrap.yml \
  -e streamnest_repo_url=https://github.com/OWNER/streamnest-platform.git

# Optional offline bootstrap from the local checkout:
ansible-playbook -i inventories/streamnest/hosts.local.yml playbooks/platform-bootstrap.yml \
  -e streamnest_repo_url=https://github.com/OWNER/streamnest-platform.git \
  -e streamnest_repo_local_path=/path/to/Media_Streaming_Platform
```

Operators use the fetched kubeconfig with `kubectl` and `argocd`. The role
uses the Kubernetes API and a pinned upstream Argo manifest; it does not run
an ad-hoc `kubectl apply` loop or shell installer. It checks out the reviewed
Git revision on the guest so the same files can be applied through the
Kubernetes API and then reconciled by Argo CD.

## Roles

| Role | Host | Purpose |
|------|------|---------|
| (inline tasks) | k3s | `k3s-server.yml` |
| `argocd_bootstrap` | k3s | Pinned Argo install + platform Applications + optional `sops-age` |

The existing NAS Apps deployments are intentionally outside this role. The
k3s workloads are OCI containers running on the NAS through the Linux VM;
duplicating them as TrueNAS native Apps would bypass Argo CD and risk the live
services. The official TrueNAS Terraform provider owns the supported VM and
storage objects; it does not pretend to own native App catalog objects.
