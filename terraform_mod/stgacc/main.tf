resource "azurerm_storage_account" "stg_acc" {
  name                             = var.stg_name
  account_replication_type         = var.account_replication_type
  account_tier                     = var.account_tier
  location                         = var.location
  resource_group_name              = var.resource_group_name
  account_kind                     = var.account_kind
  min_tls_version                  = var.min_tls_version
  https_traffic_only_enabled       = var.enable_https_traffic_only
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
  routing {
    choice = var.routing_choice
    #publish_internet_endpoints = var.publish_internet_endpoints
    publish_microsoft_endpoints = var.publish_microsoft_endpoints
  }
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
  tags = var.data_tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

resource "azurerm_private_endpoint" "blob_stg_acc_pvtep" {
  location            = var.location
  name                = "pvtepblob-${var.stg_name}"
  resource_group_name = var.resource_group_name
  subnet_id           = var.wl_subnet_id
  tags                = var.tags
  private_service_connection {
    is_manual_connection           = false
    name                           = "pvtsvcconn-pvtepblob-${var.stg_name}"
    private_connection_resource_id = azurerm_storage_account.stg_acc.id
    subresource_names              = var.blob_subresource_names
  }
  lifecycle {
    ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
  }
}

resource "null_resource" "blob_dnscheck" {
  depends_on = [azurerm_private_endpoint.blob_stg_acc_pvtep]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command     = "chmod +x dnsresolve_check.sh"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/dnsresolve_check.sh ${var.stg_name}.privatelink.blob.core.windows.net"
  }
}

resource "azurerm_private_endpoint" "table_stg_acc_pvtep" {
  location            = var.location
  name                = "pvteptable-${var.stg_name}"
  resource_group_name = var.resource_group_name
  subnet_id           = var.wl_subnet_id
  tags                = var.tags
  private_service_connection {
    is_manual_connection           = false
    name                           = "pvtsvcconn-pvteptable-${var.stg_name}"
    private_connection_resource_id = azurerm_storage_account.stg_acc.id
    subresource_names              = var.table_subresource_names
  }
  lifecycle {
    ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
  }
}

resource "null_resource" "table_dnscheck" {
  depends_on = [azurerm_private_endpoint.table_stg_acc_pvtep]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command     = "chmod +x dnsresolve_check.sh"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/dnsresolve_check.sh ${var.stg_name}.privatelink.table.core.windows.net"
  }
}