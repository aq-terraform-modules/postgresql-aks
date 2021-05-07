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

variable "kubernetes_version" {
  default = "1.16.1"
  description = "K8s version"
}

variable "admin_username" {
  default     = "remote_admin"
  type        = string
  description = "Username for node"
}

variable "public_ssh_key" {
  type        = string
  description = "Public key to login using private key pem"
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

variable "node_public_ip" {
  default     = false
  type        = bool
  description = "Public IP configuration for each node to access it from internet"
}

variable "node_count" {
  default     = 1
  type        = number
  description = "Total node for nodepool"
}

variable "node_size" {
  default     = "Standard_D2_v2"
  description = "Size for node of nodepool"
}

variable "node_auto_scale" {
  default     = false
  type        = bool
  description = "Node autoscaling"
}

variable "node_min_count" {
  default     = 1
  type        = number
  description = "Node min count with autoscaling on"
}

variable "node_max_count" {
  default     = 2
  type        = number
  description = "Node max count with autoscaling on"
}

variable "node_max_pods" {
  default     = null
  type        = number
  description = "Max pod on each node"
}

variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "enable_http_application_routing" {
  default     = false
  description = "Enable http application routing"
}