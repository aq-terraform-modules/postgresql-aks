resource "azurerm_resource_group" "aks-rg" {
  name      = var.resource_group_name
  location  = var.location

  lifecycle {
    ignore_changes  = [tags]
  }
}
