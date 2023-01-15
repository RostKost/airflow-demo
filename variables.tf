variable "client_id" {
  default   = "sp-client-id"
  sensitive = true
}

variable "client_secret" {
  default   = "sp-creds-vault"
  sensitive = true
}

variable "aad_server_app_secret" {
  default   = "aad server application hash"
  sensitive = true
}

variable "subscription_id" {
  description = "default subscription id"
  default     = "WWWW-XXXX-YYYY-ZZZZ"
  sensitive   = true
}

variable "tenant_id" {
  description = "default tenant id"
  default     = "WWWW-XXXX-YYYY-ZZZZ"
  sensitive   = true
}

variable "resource_group_name" {
  default = "nonprod-tf-rg-airflow"
}

variable "location" {
  default = "eastus"
}

variable "linux_profile" {
  type = map(string)

  default = {
    admin_username = "azureuser"
    ssh_public_key = "~/.ssh/azureuser_id_rsa.pub"
  }
}
variable "os" {
  type = map(string)

  default = {
    vm_size         = "Standard_D2ps_v5"
    os_type         = "Linux"
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"
  }
}

variable "network_profile" {
  type = map(string)

  default = {
    network_plugin     = "kubenet"
    docker_bridge_cidr = "10.43.192.1/18"
    dns_service_ip     = "10.43.128.10"
    pod_cidr           = "10.43.0.0/17" ????????
    vnet_cidr          = "10.43.0.0/17"
    subnet_cidr        = "10.43.0.0/17"
    service_cidr       = "10.43.128.0/18"
    load_balancer_sku  = "Standard"
    service_endpoints  = "Microsoft.Sql"
  }
}

variable "profile" {
  type = map(string)

  default = {
    resource_group_vnet       = "nonprod-vnet-rg-airflow"
    vnet_name                 = "nonprod-vnet-airflow"
    vnet_cidr                 = "10.13.216.0/23"
    subnet_name               = "nonprod-subnet-airflow-private-0"
    subnet_cidr               = "10.13.216.128/26"
    kubernetes_version        = "1.24.6"
    role_based_access_control = true
    nodes_count               = 2
    max_pods                  = 100
    dns_prefix                = "airflow"
    cluster_name              = "airflow-aks"
    http_application_routing  = false
    client_app_id             = "XXXX-YYYY-ZZZZ"
    server_app_id             = "WWWW-XXXX-YYYY-ZZZZ"
  }
}

variable "monitoring" {
  type = map(string)

  default = {
    workspace_name                  = "airflow-log"
    workspace_sku                   = "PerNode"
    workspace_location              = "eastus"
    log_workspace_retention_in_days = 30
    enable_oms_agent                = true
  }
}

variable "org_tags" {
  type = map(string)

  default = {
    ArchPath          = "Foundation.Platform.Airflow"
    CostCenter        = 12345
    Owner             = "Airflow Cluster Manager group"
    Product           = "Airflow Demo"
    PlatformComponent = "Airflow"
    environment       = "demo"
    site              = "eastus"
    org               = "NT"
    office            = "Chicago,IL"
  }
}