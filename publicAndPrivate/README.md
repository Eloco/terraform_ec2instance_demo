# terraform_ec2instance_demo
terraform_ec2instance_demo

## EC2 with public and private IP

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
3. modify terraform.tfvars.bak and unbak it.
4. `terraform apply` and review
5. `ssh -i "my-key-pair.pem" ec2-user@{public ip}`
