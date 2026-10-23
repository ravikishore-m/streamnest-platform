# Runbook — Fix k3s VM LAN access (bridge)

## Symptom

- VM running; guest obtained DHCP; k3s installed.  
- Admin laptop cannot reach guest SSH/API (`No route to host`).  
- Outbound from guest may work (macvtap); NAS↔guest often isolated on macvlan.

## Fix (NAS UI)

1. Short maintenance window (SSH to NAS may drop while moving the NIC).  
2. Create a **Bridge** interface; add the physical NIC as a member.  
3. Move the NAS IPv4 from the physical NIC onto the bridge.  
4. Confirm NAS management still reachable.  
5. Attach the VM NIC to the bridge; restart the VM.  
6. Confirm SSH and `kubectl get nodes` from the admin laptop.

Exact interface names and addresses: private notes only (`docs/private/`).

## Alternative

Join the guest to a private mesh VPN (e.g. Tailscale) using a key stored only in local secrets.
