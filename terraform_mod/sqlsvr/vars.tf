variable "dtags" {
  type        = map(string)
  description = "Tags to be assigned to data resources."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}

variable "sqlsvrname" {
  type        = string
  description = "Name of the SQL Server Instance."
}

variable "location" {
  type        = string
  description = "Location where the SQL Server Instance would be instantiated."
}

variable "rg_name" {
  type        = string
  description = "Name of the Resource Group where the SQL Server Instance would be created."
}

variable "administrator_login" {
  type        = string
  description = "Administrator Login for the SQL Server Instance."
  sensitive   = true
}

variable "administrator_login_password" {
  type        = string
  description = "Admin password for the database."
  sensitive   = true
}

variable "mssql_version" {
  type        = string
  description = "Version of the SQL Server Instance."
  default     = "12.0"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Allow access to SQL Instance via public network."
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

variable "azuread_authentication_only" {
  type        = bool
  default     = true
  description = "Specifies whether only AD Users and administrator for Login."
}

variable "ad_tenant_id" {
  type        = string
  description = "The tenant id of the Azure AD Administrator of this SQL Server."
  sensitive   = true
}

variable "sql_subresource_names" {
  type        = list(string)
  default     = ["sqlServer"]
  description = "List of components to be exposed via private endpoint"
}

variable "subnet_id" {
  type        = string
  description = "SubnetID where the pvt enpoint for the Instance will be created"
}