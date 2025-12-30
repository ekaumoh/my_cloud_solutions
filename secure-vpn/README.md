# Azure WireGuard VPN (Terraform) — GitHub-safe template

- WireGuard is **NOT auto-installed by default** (manual install guide included).
- Optional `cloud-init` YAML is provided **only as a reference** you can opt into.

## What this deploys

- Resource group
- VNet + subnet
- NSG with:
  - SSH **restricted to your CIDR**
  - WireGuard UDP 51820 (configurable source CIDR)
- Ubuntu 22.04 LTS VM with SSH key auth

## Quick start (VS Code friendly)

1) **Clone / open** this folder in VS Code.

2) Create your variables file:
- Copy `examples/terraform.tfvars.example` → `terraform/terraform.tfvars` (this file is gitignored)

3) Deploy:
```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform apply
```

4) SSH to the box (Terraform output prints the exact command).

5) Install WireGuard manually:
- Follow: `docs/20-manual-wireguard-setup.md`

## Optional: cloud-init WireGuard bootstrap

If you want WireGuard to be installed/configured automatically at provisioning time,
replace the VM `custom_data` file reference from:

`cloud-init/cloud-init-base.yaml` → `cloud-init/cloud-init-wireguard-optional.yaml`

> Default stays manual on purpose (safer + more transparent when sharing publicly).

## Security notes (read before publishing)

- **Never commit**:
  - `terraform.tfstate*`
  - real `terraform.tfvars`
  - any `*.key`, `client-wg.conf`, server configs, or generated QR codes  
- Restrict inbound rules as tightly as possible:
  - set `allowed_ssh_source_cidr` to **your IP/32**
  - set `allowed_wg_source_cidr` to **your IP/32** whenever possible
- Rotate keys if you ever suspect exposure: `docs/40-rotate-keys.md`

More: `SECURITY.md`
