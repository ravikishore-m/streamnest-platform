# ADR 0007 — Phase 3 bootstrap method

## Status

Accepted

## Context

First bring-up needs cloud-init, guest SSH, and k3s. Terraform provider is preferred long-term.

## Decision

1. First VM create may use the NAS API/CLI; record commands only in private operator notes.  
2. Terraform module remains the target shape; import before claiming full Terraform management.  
3. Guest install via cloud-init and/or Ansible.  
4. Credentials and kubeconfig only in local ignored files.

## Consequences

Honest bootstrap; no fake Terraform ownership; no internal paths committed.
