variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}

variable "webapp_name" {
  type        = string
  description = "Name of the webapp to be provisioned."
}

variable "location" {
  type        = string
  description = "Location where the webapp will be provisioned."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group meant to host the Instance and associated pvt endpoint."
}

variable "resource_group_id" {
  type        = string
  description = "Name of resource group meant to host the Instance and associated pvt endpoint."
}

variable "service_plan_id" {
  type        = string
  description = "App service plan that will be used to host the webapp instance."
}

variable "ob_subnet_id" {
  type        = string
  description = "The subnet delegated for webapps outbound connection."
}

variable "wl_subnet_id" {
  type        = string
  description = "Subnet where the webapp pvtendpoint will be provisioned."
}

variable "subresource_names" {
  type        = list(string)
  default     = ["sites"]
  description = "List of components to be exposed via private endpoint."
}