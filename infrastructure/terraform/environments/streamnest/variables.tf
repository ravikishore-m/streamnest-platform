variable "truenas_endpoint" {
  type        = string
  description = "TrueNAS WebSocket API endpoint, supplied privately."
  sensitive   = true
}

variable "truenas_username" {
  type        = string
  description = "Owner of the TrueNAS API key."
  sensitive   = true
}

variable "truenas_api_key" {
  type        = string
  description = "TrueNAS API key, supplied outside Git."
  sensitive   = true
}

variable "truenas_ca_cert" {
  type        = string
  description = "Path to the trusted TrueNAS CA certificate."
  default     = ""
}

variable "truenas_insecure" {
  type        = bool
  description = "Skip TrueNAS TLS verification during private bootstrap only."
  default     = false
}

variable "pool_name" {
  type        = string
  description = "Existing TrueNAS pool for platform data and the VM zvol."
}

variable "vm_name" {
  type        = string
  description = "Name of the k3s VM."
  default     = "streamnest"
}

variable "platform_dataset_name" {
  type        = string
  description = "Full ZFS dataset path for platform data."
}

variable "vm_disk_name" {
  type        = string
  description = "Full ZFS zvol path for the k3s VM boot disk."
}

variable "vm_disk_size_bytes" {
  type        = number
  description = "Size of the k3s VM zvol in bytes."
  default     = 107374182400

  validation {
    condition     = var.vm_disk_size_bytes >= 4294967296
    error_message = "The k3s VM disk must be at least 4 GiB."
  }
}

variable "vm_memory_bytes" {
  type        = number
  description = "RAM assigned to the k3s VM in bytes."
  default     = 8589934592

  validation {
    condition     = var.vm_memory_bytes >= 4294967296 && var.vm_memory_bytes <= 17179869184
    error_message = "VM memory must be between 4 GiB and 16 GiB."
  }
}

variable "vm_vcpus" {
  type        = number
  description = "Virtual CPU sockets."
  default     = 1
}

variable "vm_cores" {
  type        = number
  description = "Virtual CPU cores per socket."
  default     = 4
}

variable "vm_threads" {
  type        = number
  description = "Virtual CPU threads per core."
  default     = 1
}

variable "vm_nic_attach" {
  type        = string
  description = "Existing TrueNAS interface or bridge attached to the VM."
}

variable "vm_autostart" {
  type        = bool
  description = "Start the VM when the NAS boots."
  default     = true
}

variable "vm_running" {
  type        = bool
  description = "Desired VM runtime state; keep false for the first apply."
  default     = false
}
