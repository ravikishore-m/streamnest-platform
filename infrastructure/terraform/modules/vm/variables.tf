variable "name" {
  type        = string
  description = "VM name."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,62}$", var.name))
    error_message = "VM name must be a short DNS-safe identifier."
  }
}

variable "description" {
  type        = string
  description = "VM description."
  default     = ""
}

variable "pool_name" {
  type        = string
  description = "Existing TrueNAS pool used by this environment."
}

variable "platform_dataset_name" {
  type        = string
  description = "Full ZFS dataset path for platform data."
}

variable "vm_disk_name" {
  type        = string
  description = "Full ZFS zvol path for the VM disk."
}

variable "vm_disk_size_bytes" {
  type        = number
  description = "VM disk size in bytes."
}

variable "memory_bytes" {
  type        = number
  description = "VM memory in bytes."
}

variable "vcpus" {
  type        = number
  description = "Virtual CPU sockets."

  validation {
    condition     = var.vcpus >= 1 && var.vcpus <= 4
    error_message = "vcpus must be between 1 and 4 for the single-node budget."
  }
}

variable "cores" {
  type        = number
  description = "Virtual CPU cores per socket."

  validation {
    condition     = var.cores >= 1 && var.cores <= 8
    error_message = "cores must be between 1 and 8 for the single-node budget."
  }
}

variable "threads" {
  type        = number
  description = "Virtual CPU threads per core."

  validation {
    condition     = var.threads >= 1 && var.threads <= 2
    error_message = "threads must be between 1 and 2."
  }
}

variable "nic_attach" {
  type        = string
  description = "TrueNAS interface or bridge for the VM NIC."
}

variable "autostart" {
  type        = bool
  description = "VM autostart setting."
}

variable "running" {
  type        = bool
  description = "Desired VM runtime state."
}
