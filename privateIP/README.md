# terraform_ec2instance_demo
terraform_ec2instance_demo

## EC2 with private IP

1. u need to unbak ./terraform.tfvars.bak, and fill the aws credentials
2. use the aws cli to create ec2 ssh-key-pair
```
❯ aws ec2 create-key-pair \
    --key-name my-key-pair \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > my-key-pair.pem
```
3. `terraform init`
3. `terraform apply` and review
