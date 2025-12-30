variable "prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "eka-westvpn"
}

variable "location" {
  description = "Azure region for the VPN"
  type        = string
  default     = "westus"
}

variable "vm_size" {
  description = "Size of the VPN VM"
  type        = string
  default     = "Standard_B1ls"
}

variable "vm_admin_username" {
  description = "Admin username for the VPN VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file (e.g., ~/.ssh/id_ed25519.pub)"
  type        = string
}

variable "allowed_ssh_source_cidr" {
  description = "CIDR allowed to SSH (recommended: your_public_ip/32)"
  type        = string
}

variable "allowed_wg_source_cidr" {
  description = "CIDR allowed to reach UDP/51820 (recommended: your_public_ip/32). Use 0.0.0.0/0 only if needed."
  type        = string
  default     = "0.0.0.0/0"
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "wireguard_port" {
  description = "WireGuard UDP port"
  type        = number
  default     = 51820
}
