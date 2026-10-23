# Security

## Reporting

Report vulnerabilities privately to the repository owner. Do not open public issues with exploit details or site inventory.

## Secrets and privacy

Never commit:

- `.env`, `secrets.yaml`, kubeconfigs, Terraform state, Vault tokens, API keys  
- Personal identifiers, private chat IDs, or home addresses  
- LAN/VPN IPs, MagicDNS names, SSH aliases, usernames  
- Pool/dataset/zvol paths, disk serials, media library layouts  

Use `config/local.yaml` and `docs/private/` (gitignored).

## Cluster

- Single-env k3s — treat as semi-trusted until NetworkPolicies + Vault are live  
- Do not expose kube-apiserver, Argo CD, or Vault on the public Internet  

## Supply chain

Pin images by digest; scan before sync.

## AI agent

No cluster-admin or unrestricted remediation until decision D8 is closed.
