# Encrypted cluster secrets (SOPS)

Plaintext secrets are **never** committed. Tracked files here are **SOPS-encrypted** (`*.enc.yaml`).

## Setup (once)

```bash
# Install: brew install age sops
mkdir -p config/local
age-keygen -o config/local/age.key   # gitignored
# Put the public key into .sops.yaml (age: recipients)
```

## Encrypt / edit

```bash
export SOPS_AGE_KEY_FILE="$PWD/config/local/age.key"
cp secrets/streamnest.enc.yaml.example /tmp/streamnest.yaml   # fill real values
sops --encrypt --age "$(grep 'public key:' config/local/age.key | awk '{print $NF}')" \
  /tmp/streamnest.yaml > secrets/streamnest.enc.yaml
sops secrets/streamnest.enc.yaml   # edit in place
```

## Apply to cluster

```bash
# The supported bootstrap path is Ansible + the Kubernetes API. Keep the age
# key outside Git and pass it only from the operator's local environment.
cd infrastructure/ansible
ansible-playbook -i inventories/streamnest/hosts.local.yml \
  playbooks/platform-bootstrap.yml \
  -e streamnest_repo_local_path=/path/to/Media_Streaming_Platform \
  -e sops_age_key_file=/path/to/config/local/age.key
```

The playbook creates or updates only the narrowly scoped cluster Secret needed
by the configured secret integration and uses `no_log`. It does not print
secret values. Vault is the long-term runtime secret authority; SOPS is kept
for bootstrap material that must exist before Vault is initialized.
