resource "azurerm_resource_group" "aks-cluster-rg" {
  name      = "${var.resource_group_name}-cluster"
  location  = var.location

  tags = {
    Environment = var.tag_env
  }

  lifecycle {
    ignore_changes  = [tags]
  }
}

# Log analytics for Container monitoring
resource "azurerm_log_analytics_workspace" "aks-log-wspace" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.aks_name}-workspace-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "aks-log-solution" {
    solution_name         = "ContainerInsights"
    location              = var.location
    resource_group_name   = azurerm_resource_group.aks-cluster-rg.name
    workspace_resource_id = azurerm_log_analytics_workspace.aks-log-wspace.id
    workspace_name        = azurerm_log_analytics_workspace.aks-log-wspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "${var.aks_name}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-cluster-rg.name
  dns_prefix          = "${var.aks_name}-dns"

  #  Resource group for node
  node_resource_group = "${var.resource_group_name}-node"

  default_node_pool {
    name                = var.nodepool_name
    type                = var.nodepool_type
    vm_size             = var.node_size
    enable_auto_scaling = var.node_auto_scale
    node_count          = ${var.node_auto_scale == false ? var.node_count : 1}
    max_count           = ${var.node_auto_scale == true ? var.node_max_count : 1}
    min_count           = ${var.node_auto_scale == true ? var.node_min_count : 1}
  }

  identity {
    type = "SystemAssigned"
  }

  # Network
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
  }

  # Addon
  addon_profile {
    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks-log-wspace.id
    }

    kube_dashboard {
      enabled = true
    }
  }

  #  Tags
  tags = {
    Environment = var.tag_env
  }

  lifecycle {
    ignore_changes  = [tags]
  }
}