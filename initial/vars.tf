// Networking vars
variable "old_wl_sn_name" {
  type        = string
  description = "Name of the workload subnet."
}

variable "net_rg_name" {
  type        = string
  default     = "rg-management-prod-fc"
  description = "resource group where this needs to be provisioned."
} #record data block

variable "vnet_name" {
  type        = string
  description = "resource group where this needs to be provisioned."
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    name              = string
    addr_prefix       = list(string)
    enable_delegation = bool
  }))
}

// Storage Account vars
variable "stg_name" {
  type        = string
  description = "Name of the storage account"
}

variable "data_tags" {
  type        = map(string)
  description = "Tags to be data classification of data in rest"
}

variable "subresource_names" {
  type        = list(string)
  default     = ["blob"]
  description = "List of components in storage account to be exposed via private endpoint"
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Replication type for the storage account"
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "The account tier to be used for storage account"
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Kind of account to be used for the storage account"
}

variable "min_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "minimum tls version to be used for connection"
}

variable "enable_https_traffic_only" {
  type        = bool
  default     = true
  description = "enforce https communication with storage account"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  default     = false
  description = "Allow nested items in blob hosted in container to be public"
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  default     = false
  description = "Allow storage account to be replicated across tenants"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow access to storage account via public network"
}


// VM vars
variable "gh_runner_rg_name" {
  description = "name of the resrouce group where runner would be provisioned"
  type        = string
}

variable "num_runners" {
  type        = number
  description = "value of the number of github runners to be provisioned"
  default     = 1
}

variable "location" {
  description = "Location where the resources would be provisioned"
  type        = string
  default     = "francecentral"
}

variable "vm_name" {
  description = "name of the vm to be provisioned"
  type        = string
}

variable "vm_size" {
  type        = string
  description = "size the linux vm to be created"
  default     = "Standard_B2s"
}

variable "vm_user" {
  type        = string
  description = "name of the user for the linux vm to be created"
  default     = "azureuser"
}

variable "server_url" {
  description = "Github Enterprise Server FQDN"
  type        = string
  default     = "github.schneider-electric.com"
}

variable "org" {
  description = "Organization name in the github enterprise server"
  type        = string
}

variable "runner_group_name" {
  description = "Name of the runner Group Under which the runner would be provisioned"
  type        = string
}

variable "runner_label" {
  description = "Labels that can be associated with the runner."
  type        = string
}

variable "runner_wd" {
  description = "Name of the Working Directory for the runner"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources"
}

variable "vm_id_name" {
  description = "Name for the managed identity that would be attached to the vm"
  type        = string
}

//kv vars
variable "kvname" {
  description = "Name for the kv to be used by the gh runners"
  type        = string
}