terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "11587646-7be4-41f6-959c-39bc41011124"
}

resource "azurerm_resource_group" "rg-k8s" {
    name = "rg-k8s-lab"
    location = "eastus2"
  
}

resource "azurerm_kubernetes_cluster" "k8s-cluster" {
    name = "live_cluster"
    location = azurerm_resource_group.rg-k8s.location
    resource_group_name = azurerm_resource_group.rg-k8s.name
    dns_prefix = "live-cluster1"

    default_node_pool {
        name = "default"
        node_count = "4"
        vm_size = "Standard_D2_v2"
      
    }
    identity {
      type = "SystemAssigned"
    }
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.k8s-cluster.kube_config_raw
    sensitive = true
}

resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.k8s-cluster.kube_config_raw
  filename = "C:\\Users\\gusta\\.kube\\config"
}