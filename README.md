# Terraform module to create an Always Free cluster on OCI

This module provisions an *Always Free* cluster on *Oracle Cloud Infrastructure (OCI)*.  
Ressources :  
- A Virtual Cloud Network (VCN)
- An Internet Gateway
- Subnets
- 4 Compute Instances (always-free eligible)  

```bash
terraform init
terraform plan -out=plan
terraform apply -auto-approve plan
```
