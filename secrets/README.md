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
./scripts/apply-sops-secrets.sh
```

Decrypts locally and creates/updates Kubernetes Secrets (registry pull, Argo admin bcrypt). Does not print secret values.
