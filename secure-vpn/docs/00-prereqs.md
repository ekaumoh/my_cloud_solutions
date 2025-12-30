# Prereqs

## Local tooling
- Azure CLI
- Terraform >= 1.6
- SSH client (macOS has this)

## Azure auth
```bash
az login
az account show
# optionally:
az account set --subscription "<your-subscription-id>"
```

## SSH key
Create an SSH key if you don’t have one:
```bash
ssh-keygen -t ed25519 -C "azure-wireguard-vpn"
```
