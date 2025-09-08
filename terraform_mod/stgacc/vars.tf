variable "stg_name" {
  type        = string
  description = "Name of the storage account."
}

variable "data_tags" {
  type        = map(string)
  description = "Tags to be data classification of data in rest."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}

variable "blob_subresource_names" {
  type        = list(string)
  default     = ["blob"]
  description = "List of components in storage account to be exposed via private endpoint."
}

variable "table_subresource_names" {
  type        = list(string)
  default     = ["table"]
  description = "List of components in storage account to be exposed via private endpoint."
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Replication type for the storage account."
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "The account tier to be used for storage account."
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Kind of account to be used for the storage account."
}

variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "minimum tls version to be used for connection."
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "enforce https communication with storage account."
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  default     = false
  description = "Allow nested items in blob hosted in container to be public."
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  default     = false
  description = "Allow storage account to be replicated across tenants."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow access to storage account via public network."
}

variable "location" {
  type        = string
  description = "Location where the AppInsights instance needs to be provisioned."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where this needs to be provisioned."
}

variable "wl_subnet_id" {
  type        = string
  description = "Subnet where the webapp pvtendpoint will be provisioned."
}

variable "routing_choice" {
  type        = string
  default     = "MicrosoftRouting"
  description = "Choice between internet routing or microsoft routing"
}

# variable "publish_internet_endpoints" {
#   type        = bool
#   default     = false
#   description = "Publish Internet endpoint"
# }

variable "publish_microsoft_endpoints" {
  type        = bool
  default     = true
  description = "Publish Microsoft endpoint"
}