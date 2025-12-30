output "vpn_public_ip" {
  description = "Public IP of the VPN server"
  value       = azurerm_public_ip.vpn_pip.ip_address
}

output "ssh_connection" {
  description = "SSH command you can use to connect"
  value       = "ssh ${var.vm_admin_username}@${azurerm_public_ip.vpn_pip.ip_address}"
}

output "wireguard_port" {
  description = "WireGuard UDP port"
  value       = var.wireguard_port
}
