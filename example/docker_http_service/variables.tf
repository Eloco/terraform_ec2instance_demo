variable "instance_name" {
  description = "Name of the instance to be created"
  default     = "awsbuilder-demo"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-elocotest01"
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-09d56f8956ab235b3"
}

variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 1
}

variable "ami_key_pair_name" {
  default = "my-key-pair"
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#resource "aws_key_pair" "my_key_pair" {
#  key_name   = "my-key-pair"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD......"
#}

