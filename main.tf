# Specifies the required provider, in this case, the Azure Resource Manager (azurerm) provider.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

# Configures the Azure provider using environment variables for authentication.
provider "azurerm" {
  features {}

  client_id       = var.ARM_CLIENT_ID       # Azure Client ID from environment variables or passed in variable.
  client_secret   = var.ARM_CLIENT_SECRET   # Azure Client Secret for authentication.
  tenant_id       = var.ARM_TENANT_ID       # Azure Active Directory Tenant ID.
  subscription_id = var.ARM_SUBSCRIPTION_ID # Azure Subscription ID.
}

# Creates an Azure Resource Group in the Canada Central region.
resource "azurerm_resource_group" "resource_group" {
  name     = "azure_devops_resource_group" # Name of the resource group.
  location = "Canada Central"              # Region where the resource group will be created.
}

# Creates an Azure Kubernetes Service (AKS) cluster within the resource group.
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "azure_devops_aks_cluster"  # Name of the AKS cluster.
  location            = azurerm_resource_group.aks_rg.location  # Location is set to match the resource group.
  resource_group_name = azurerm_resource_group.aks_rg.name      # Associates the cluster with the resource group.
  dns_prefix          = "azure_devops_aks_cluster_dns"          # DNS prefix for the cluster.

  # Configures the default node pool for the AKS cluster.
  default_node_pool {
    name                = "cluster_pool"          # Name of the node pool.
    vm_size             = "Standard_D2s_v2"       # Specifies the virtual machine size for the nodes.
    auto_scaling_enabled = true                   # Enables auto-scaling for the node pool.
    node_count          = 3                       # Initial number of nodes.
    min_count           = 1                       # Minimum number of nodes when scaling down.
    max_count           = 5                       # Maximum number of nodes when scaling up.
  }

  # Enables system-assigned managed identity for the AKS cluster.
  identity {
    type = "SystemAssigned"
  }
}

# Outputs the Kubernetes configuration (kubeconfig) for accessing the AKS cluster.
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw  # Raw kubeconfig value.
  sensitive = true  # Marks the output as sensitive to prevent it from being displayed in plain text.
}
