resource "azurerm_resource_group" "aks-cluster-rg" {
  name      = "${var.resource_group_name}-cluster"
  location  = var.location

  tags = {
    Environment = "Development"
  }

  lifecycle {
    ignore_changes  = [tags]
  }
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "${var.aks_name}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
  dns_prefix          = "${var.aks_name}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  #  Resource group for node
  node_resource_group = "${var.resource_group_name}-node"
  
  tags = {
    Environment = "Development"
  }

  lifecycle {
    ignore_changes  = [tags]
  }
}