variable "app_command_line" {
  description = "The command line to be used for the web app."
  type        = string
  default     = "\n"
}

variable "appsettings" {
  type        = map(string)
  description = "Values to be supplied the webapps for configuration"
  default     = {}
}

variable "client_affinity_enabled" {
  type        = bool
  default     = true
  description = "Enable client affinity for the webapp"
}

variable "https_only" {
  type        = bool
  default     = true
  description = "Ensure endpoint is exposed only via HTTPS"
}

variable "location" {
  type        = string
  description = "Location where the webapp will be provisioned"
}

variable "node_version" {
  type        = string
  description = "The version of node to be used for the webapp"
  default     = "20-lts"
}

variable "ob_subnet_id" {
  type        = string
  description = "The subnet delegated for webapps outbound connection"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow access to webapp Instance via public network"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group meant to host the RedisCache Instance and associated pvt endpoint"
}

variable "retention_in_days" {
  description = "The number of days to retain logs."
  type        = number
  default     = 3
}

variable "retention_in_mb" {
  description = "The maximum size in megabytes that the log files can use."
  type        = number
  default     = 100
}

variable "service_plan_id" {
  type        = string
  description = "App service plan that will be used to host the webapp instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet where the webapp pvtendpoint will be provisioned"
}

variable "subresource_names" {
  type        = list(string)
  default     = ["sites"]
  description = "List of components to be exposed via private endpoint"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be associated with the webapp and the pvtendpoint resource"
}

variable "webapp_name" {
  type        = string
  description = "Name of the webapp to be provisioned"
}

variable "ftp_publish_basic_authentication_enabled" {
  type        = bool
  default     = false
  description = "value to enable basic authentication for ftp publish."
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

variable "ftps_state" {
  type        = string
  description = "The state of FTPS for the webapp."
  default     = "FtpsOnly"
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  description = "value of user identities to be passed to webapp."
  default     = []
}

variable "vnet_route_all_enabled" {
  type        = bool
  default     = true
  description = "Enable vnet route all for the webapp."
}

variable "allowed_origins" {
  type        = list(string)
  default     = [""]
  description = "CORS Allowed."
}

variable "always_on" {
  type        = bool
  default     = true
  description = "Enable always on for the webapp."
}

variable "use_32_bit_worker" {
  type        = bool
  default     = true
  description = "Enable 32 bit worker for the webapp."
}

variable "connection_strings" {
  description = "List of connection strings"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}