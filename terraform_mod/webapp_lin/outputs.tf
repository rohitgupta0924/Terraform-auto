output "wap_details" {
  value       = azurerm_linux_web_app.webapp
  description = "webapp all details"
}

output "wap_pvtep_details" {
  value       = azurerm_private_endpoint.pep
  description = "Endpoint details"
}