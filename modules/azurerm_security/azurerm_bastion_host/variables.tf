variable "bastion_name" {
  description = "The name of the Bastion Host"
  type        = string
  
}

variable "location" {
  description = "The Azure region where the Bastion Host will be created"
  type        = string
  
}

variable "rg_name" {
  description = "The name of the resource group in which to create the Bastion Host"
  type        = string
  
}

variable "vnet_name" {
  description = "The name of the Virtual Network where the Bastion Host subnet is located"
  type        = string
  
}
variable "bastion_sub_id" {
  description = "The name of the subnet to host the Bastion Host. This subnet must be named 'AzureBastionSubnet'"
  type        = string
  
}

variable "bastion_pip_id" {
  description = "The name of the Public IP"
  type        = string
  
}