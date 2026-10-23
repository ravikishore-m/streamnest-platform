# Privacy policy for this repository

This repo is for architecture and automation **templates**. It must not contain:

| Forbidden in Git | Where it belongs |
|------------------|------------------|
| Personal names beyond public git author if you choose | Git config locally |
| Home/lab IPs, Tailscale IDs, MagicDNS | `config/local.yaml`, `docs/private/` |
| NAS pool/dataset paths, disk models/serials | Private inventory |
| SSH hosts, usernames, key paths | Local ansible inventory |
| Media library sizes/paths | Private notes |
| API tokens, kubeconfigs | `secrets.yaml` / `.kube/` |

CI blocks common secret filenames. Review every PR for accidental inventory.
