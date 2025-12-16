variable "nic_ids" {
  description = "Map of NIC IDs"
  type        = map(string)
}

variable "nsg_ids" {
  description = "Map of NSG IDs"
  type        = map(string)
}

variable "nic_nsg_map" {
  description = "Mapping of NICs to NSGs"
  type = map(object({
    nic_key = string
    nsg_key = string
  }))
}
