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
3. `terraform init`
3. `terraform apply` and review
4. `ssh -i "my-key-pair.pem" ec2-user@{public ip}`

see more at https://asciinema.org/a/tj58mIKF3SkNw4RIBjuyqWZ5V
