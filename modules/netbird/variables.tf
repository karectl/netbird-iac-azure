
variable "region" {
  description = "The Azure region to deploy resources in."
  type        = string
}

variable "azure_tetre_subscription_id" {
  description = "The subscription ID for the TETRE Azure resources."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}

variable "common_tags" {
  description = "A map of common tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "admin_password" {
  type      = string
  sensitive = true
}