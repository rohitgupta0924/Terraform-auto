variable "sqldbname" {
  type        = string
  description = "Name of the DB to be created."
}

variable "server_id" {
  type        = string
  description = "ID of the SQL Server, under which this would be provisioned."
}

variable "stgacctype" {
  type        = string
  description = "Storage account type for the database."
}

variable "sku_name" {
  type        = string
  description = "SKU name for the database."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to resources."
}