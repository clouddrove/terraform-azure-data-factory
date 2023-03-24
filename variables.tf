#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}
variable "repository" {
  type        = string
  default     = ""
  description = "Terraform current module repo"
}

## Common Variables

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the module creation."
}

variable "machine_count" {
  type        = number
  default     = 0
  description = "Number of Virtual Machines to create."
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location where resource should be created."
}

variable "create" {
  type        = string
  default     = "60m"
  description = "Used when creating the Resource Group."
}

variable "update" {
  type        = string
  default     = "60m"
  description = "Used when updating the Resource Group."
}

variable "read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Resource Group."
}

variable "delete" {
  type        = string
  default     = "60m"
  description = "Used when deleting the Resource Group."
}

# Identity
variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
  type        = list(string)
  default     = null
}
variable "key_vault_id" {
  type    = string
  default = null
}
variable "principal_id" {
  type        = list(string)
  default     = []
  description = " The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created."
}
variable "cmk_encryption_enabled" {
  type    = bool
  default = false
}
variable "shared_access_key_enabled" {
  type        = bool
  default     = true
  description = " Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is true."
}

# Private endpoint

variable "virtual_network_id" {
  type        = string
  default     = ""
  description = "The name of the virtual network"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "The resource ID of the subnet"
}

variable "enable_private_endpoint" {
  type        = bool
  default     = false
  description = "enable or disable private endpoint to storage account"
}

variable "existing_private_dns_zone" {
  type        = string
  default     = null
  description = "Name of the existing private DNS zone"
}

variable "existing_private_dns_zone_resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the existing resource group"
}

variable "private_dns_zone_name" {
  type        = string
  default     = "privatelink.blob.core.windows.net"
  description = "The name of the private dns zone name which will used to create private endpoint link."
}