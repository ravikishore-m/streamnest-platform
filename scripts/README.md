# Path tooling

Operational shell scripts were removed by ADR 0009.

Path 1 uses Terraform and Ansible. Path 2 uses GitHub Actions and Argo CD.
Secrets are delivered through the approved in-cluster SOPS/Vault path and
application configuration is reconciled from Git. Keep operator-only
inventory and credentials under ignored local configuration or the documented
secret store.
