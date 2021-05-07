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
resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 6
}

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
  kubernetes_version  = var.kubernetes_version

  #  Resource group for node
  node_resource_group = "${var.resource_group_name}-node"

  
  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = var.public_ssh_key
    }
  }

  default_node_pool {
    name                  = var.nodepool_name
    type                  = var.nodepool_type
    vm_size               = var.node_size
    enable_node_public_ip = var.node_public_ip
    enable_auto_scaling   = var.node_auto_scale
    node_count            = var.node_auto_scale == false ? var.node_count : null
    max_count             = var.node_auto_scale == true ? var.node_max_count : null
    min_count             = var.node_auto_scale == true ? var.node_min_count : null
    max_pods              = var.node_max_pods
  }

  identity {
    type = "SystemAssigned"
  }

  # Network
  network_profile {
    load_balancer_sku = "Standard"
    outbound_type     = "loadBalancer"
    network_plugin    = "kubenet"
    # Other option will be default value from terraform
    # network_policy     = var.network_policy
    # dns_service_ip     = var.net_profile_dns_service_ip
    # docker_bridge_cidr = var.net_profile_docker_bridge_cidr
    # outbound_type      = var.net_profile_outbound_type
    # pod_cidr           = var.net_profile_pod_cidr
    # service_cidr       = var.net_profile_service_cidr
  }

  # Addon
  addon_profile {
    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks-log-wspace.id
    }

    http_application_routing {
      enabled = var.enable_http_application_routing
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