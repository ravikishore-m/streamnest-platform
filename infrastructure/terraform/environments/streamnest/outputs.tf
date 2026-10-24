output "vm_id" {
  description = "TrueNAS numeric ID of the managed k3s VM."
  value       = module.k3s_streamnest.vm_id
}

output "vm_name" {
  description = "Managed k3s VM name."
  value       = module.k3s_streamnest.vm_name
}

output "platform_dataset" {
  description = "Managed platform dataset path."
  value       = module.k3s_streamnest.platform_dataset
}

output "vm_disk" {
  description = "Managed k3s VM zvol path."
  value       = module.k3s_streamnest.vm_disk
}
