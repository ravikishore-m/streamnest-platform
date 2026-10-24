output "vm_id" {
  description = "TrueNAS VM ID."
  value       = truenas_vm.k3s.id
}

output "vm_name" {
  description = "TrueNAS VM name."
  value       = truenas_vm.k3s.name
}

output "platform_dataset" {
  description = "Platform dataset path."
  value       = truenas_dataset.platform.name
}

output "vm_disk" {
  description = "VM zvol path."
  value       = truenas_zvol.vm_disk.name
}
