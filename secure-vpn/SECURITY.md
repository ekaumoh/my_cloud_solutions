# Security Policy & Publishing Checklist

## Do not commit secrets
This project is designed to be safe to publish, but **Terraform state and VPN keys are secrets**.

Never commit:
- `terraform.tfstate*` (contains resource IDs, IPs, sometimes credentials)
- `terraform.tfvars` (often contains IPs, paths, environment specifics)
- WireGuard keys/configs (`*.key`, `wg0.conf`, `client-wg*.conf`)
- Any SSH private keys / certificates

This repo includes a `.gitignore`, but **you are still responsible** for checking `git status` before pushing.

## Recommended hardening
- Use SSH keys only (no passwords).
- Limit SSH inbound to **your current public IP/32**.
- Limit WireGuard inbound to **your IP/32** when feasible.
- Use a small VM size and keep OS updated.
- Prefer remote state (Azure Storage) for non-demo usage.

## If you accidentally committed secrets
1. Immediately rotate:
   - WireGuard keys
   - SSH keys (if affected)
2. Remove secrets from Git history:
   - Use `git filter-repo` or BFG
3. Invalidate any exposed credentials.

## Reporting
If you discover a security issue in the template itself, open an issue describing:
- what you found
- how to reproduce
- suggested mitigation
