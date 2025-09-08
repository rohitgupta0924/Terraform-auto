variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}

variable "enable_system_assigned_identity" {
  type        = bool
  default     = true
  description = "Enable system assigned identity for the webapp."
}

variable "enable_user_assigned_identity" {
  type        = bool
  default     = false
  description = "Enable user assigned identity for the webapp."
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  description = "value of user identities to be passed to webapp."
  default     = []
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
  description = "Name of resource group meant to host the RedisCache Instance and associated pvt endpoint."
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

variable "appsettings" {
  type        = map(string)
  description = "Values to be supplied the webapps for configuration."
  default     = {}
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow access to webapp Instance via public network."
}

variable "client_affinity_enabled" {
  type        = bool
  default     = false
  description = "Enable client affinity for the webapp."
}

variable "client_certificate_enabled" {
  type        = bool
  default     = false
  description = "Enable client certificate for the webapp."
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Ensure endpoint is exposed only via HTTPS."
}

variable "subresource_names" {
  type        = list(string)
  default     = ["sites"]
  description = "List of components to be exposed via private endpoint."
}

variable "always_on" {
  type        = bool
  default     = false
  description = "Keep webapp always on."
}

variable "use_32_bit_worker" {
  type        = bool
  default     = true
  description = "Use 32 bit worker instead of 64bit."
}

variable "vnet_route_all_enabled" {
  type        = bool
  default     = true
  description = "Route all traffic through VNET."
}

variable "webdeploy_publish_basic_authentication_enabled" {
  type        = bool
  default     = true
  description = "Enable basic authentication for webdeploy."
}

variable "virtual_applications" {
  description = "List of virtual applications to add"
  type = list(object({
    physical_path = string
    preload       = bool
    virtual_path  = string
  }))
  default = []
}
