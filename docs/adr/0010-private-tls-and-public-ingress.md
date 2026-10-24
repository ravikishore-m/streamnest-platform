# ADR 0010 — Private platform TLS and deferred public ingress

## Status

Accepted for the current single-environment bootstrap; public ACME issuance is
deferred pending operator-provided DNS and ingress evidence.

## Context

Vault requires encrypted transport, but the platform does not yet have a
verified public DNS zone, approved ingress controller exposure, or an ACME
account email/provider credential that may be stored outside Git. Enabling a
public certificate without those facts would either publish an internal
endpoint or require unsafe secret handling.

## Decision

1. cert-manager is installed from the pinned official chart.
2. Vault uses an in-cluster self-signed certificate for private service DNS.
3. External application ingress and Let's Encrypt are not enabled by default.
4. When approved, add a separately reviewed ACME `ClusterIssuer` using
   HTTP-01 or DNS-01, with the email and DNS credentials supplied through
   private operator configuration or Vault—not Git.
5. Administrative endpoints remain private; Tailscale or an equivalent private
   access path is preferred over public exposure.

## Consequences

The current manifests can establish encrypted internal Vault traffic without
inventing a public hostname. Browser URLs and path-based ingress remain a
separate application-path change that must be tested on the actual network.

## Security and recovery

ACME account keys and DNS API credentials must be rotated and revocable. If
certificate issuance fails, keep the private self-signed service certificate
for internal control-plane traffic and do not weaken TLS verification. Revoke
or replace certificates through cert-manager after fixing the provider or DNS
configuration.
