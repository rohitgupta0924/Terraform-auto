#Existing Networking vars
variable "wl_sn_name" {
  type        = string
  description = "Name of the workload subnet."
}

variable "ob_sn_name" {
  type        = string
  description = "Name of the outbound subnet used for delegation."
}

variable "vnet_name" {
  type        = string
  description = "Name of the vnet."
}

variable "net_rg_name" {
  type        = string
  default     = "rg-management-prod-fc"
  description = "resource group where net components are hosted."
}

# Location
variable "location" {
  type        = string
  description = "Location where the Resources needs to be provisioned."
  default     = "francecentral"
}

# ResourceGroup
variable "rg_name" {
  type    = string
  default = "Name of the resource group that would host the resoures."
}

# misc
variable "env" {
  type        = string
  description = "Environment where the resources are provisioned."
}

variable "seqnum" {
  type        = string
  description = "SeqNum to be Appended to resources."
  default     = "01"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}

variable "data_tags" {
  type        = map(string)
  description = "Tags to be data classification of data in rest."
  default = {
    "SEALZ-DataClassification" = "SE-Restricted"
  }
}

#sql server details
variable "sqlsvrname" {
  type        = string
  description = "Name of the SQL Server Instance."
}

variable "administrator_login" {
  type        = string
  description = "Administrator Login for the SQL Server Instance."
  sensitive   = true
}

variable "ad_login_username" {
  type        = string
  description = "Azure AD login Name for SQL Server."
  sensitive   = true
}

variable "ad_object_id" {
  type        = string
  description = "Azure AD login entity object id for SQL Server."
  sensitive   = true
}

variable "ad_tenant_id" {
  type        = string
  description = "The tenant id of the Azure AD Administrator of this SQL Server."
  sensitive   = true
}

variable "sqldbname" {
  type        = string
  description = "Name of the DB to be created."
}

variable "stgacctype" {
  type        = string
  description = "Storage account type for the database."
}

variable "sku_name" {
  type        = string
  description = "SKU name for the database."
}

#stg account details
variable "stgaccname" {
  type        = string
  description = "Name of the storage account."
}

variable "table_names" {
  type    = list(string)
  default = ["RawData", "ProcessedData"]
}

variable "container_names" {
  type    = list(string)
  default = ["iothubevents", "newgensiteimages"]
}

#webapp details:
variable "service_plan_name_windows1" {
  type        = string
  description = "Name of the asp."
}

variable "asp_sku_windows1" {
  type        = string
  description = "Sku of windows asp."
}

variable "service_plan_name_windows2" {
  type        = string
  description = "Sku of linux asp."
}

variable "asp_sku_windows2" {
  type        = string
  description = "Sku of windows asp."
}

variable "webappfename" {
  type        = string
  description = "Name of the frontend webapp to be deployed."
}

variable "webappbename" {
  type        = string
  description = "Name of the backend webapp to be deployed."
}

variable "webjobbename" {
  type        = string
  description = "Name of the backend webapp to be deployed."
}