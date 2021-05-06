resource "azurerm_resource_group" "aks-rg" {
  name      = var.resource_group_name
  location  = var.location

  lifecycle {
    ignore_changes  = [tags]
  }
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.aks_name}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = "${var.aks_name}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }

  lifecycle {
    ignore_changes  = [tags]
  }
}