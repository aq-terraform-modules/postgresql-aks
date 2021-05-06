variable "resource_group_name" {
  description = "Resource group to contains all resource for this module"
}

variable "location" {
  default     = "southeastasia"
  description = "Default location for this module"
}

variable "aks_name" {
  description = "Name for logic app"
}

variable "tag_env" {
  description = "Environment tag"
}

variable "nodepool_name" {
  default     = "default"
  description = "Name for nodepool that will contain all nodes"
}

variable "nodepool_type" {
  default     = "VirtualMachineScaleSets"
  description = "Name for nodepool that will contain all nodes"
}

variable "node_count" {
  default     = "1"
  description = "Total node for nodepool"
}

variable "node_size" {
  default     = "Standard_D2_v2"
  description = "Size for node of nodepool"
}

variable "node_auto_scale" {
  description = "Node autoscaling"
}

variable "node_min_count" {
  default     = 1
  description = "Node min count with autoscaling on"
}

variable "node_max_count" {
  default     = 2
  description = "Node max count with autoscaling on"
}

variable log_analytics_workspace_sku {
    default = "PerGB2018"
}