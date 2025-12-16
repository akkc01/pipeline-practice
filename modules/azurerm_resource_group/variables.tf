variable "resource_groups" {
  description = "A map of resource groups to create. The key of the map will be used as the resource group identifier."
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string), {})
  }))
  default = {}
  
}
