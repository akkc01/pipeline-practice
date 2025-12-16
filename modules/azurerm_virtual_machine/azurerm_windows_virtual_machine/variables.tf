variable "wvm" {
  description = "Configuration for Windows VMs, VNets, Subnets, and NICs"
  type = map(object({
    rg_key          = string
    location        = string
    kv_rg           = string
    kv_name         = string
    username_secret = string
    password_secret = string
    vm_name         = string
    size            = string
    nic_name        = string

    os_disk = optional(object({
      name                 = optional(string)
      caching              = optional(string)
      storage_account_type = optional(string)
      disk_size_gb         = optional(number)
    }))

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
  }))
}



variable "rg_name" {
  description = "Map of RG names from RG module"
  type        = map(string)
}
