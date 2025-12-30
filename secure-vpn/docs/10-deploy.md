# Deploy

```bash
cd terraform
cp ../examples/terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your values

terraform init
terraform apply
```

After apply, copy the `ssh_connection` output and SSH in.
