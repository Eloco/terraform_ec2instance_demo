# create by https://harshitdawar.medium.com/launching-a-vpc-with-public-private-subnet-in-aws-using-terraform-191188e6cad4

# ec2 configuration
resource "aws_instance" "demo_ec2" {

    depends_on = [
      aws_vpc.demo_vpc,
      aws_subnet.public_subnet,
      aws_subnet.private_subnet,
      aws_security_group.normal_rule,
    ]

    # AMI ID [I have used my custom AMI which has some softwares pre installed]
    # ami                    = var.ami_id
    ami                    = data.aws_ami.amazon-linux-2.id
    count                  = var.number_of_instances
    instance_type          = var.instance_type
    #subnet_id              = var.subnet_id
    subnet_id              =  aws_subnet.public_subnet.id

    key_name               = var.ami_key_pair_name

    # Security group ID's
     vpc_security_group_ids = [aws_security_group.normal_rule.id]

	tags = {
        Name          = "Webserver_From_Terraform"
        Terraform     = "true"
        Environment   = "dev"
        # Environment   = "production"
    }

    # Installing required softwares into the system!
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("./my-key-pair.pem")
      host = aws_instance.demo_ec2[0].public_ip
    }
    # associate_public_ip_address = true

    # Code for installing the softwares!
    provisioner "remote-exec" {
      inline = [
          #"sudo yum update -y",
          "date",
      ]
  }
}


#resource "aws_security_group" "vpc" {
#  name_prefix = "vpc"
#  vpc_id = aws_vpc.demo_vpc.id
#}
#
#resource "aws_security_group" "public" {
#  name_prefix = "public"
#}

#resource "aws_security_group_rule" "sg_rule" {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  source_security_group_id = [
#    aws_security_group.vpc.id,
#    aws_security_group.public.id
#  ]
#}

## in/out port configuration
#resource "aws_security_group_rule" "ssh_ingress" {
#  type        = "ingress"
#  from_port   = 22
#  to_port     = 22
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.vpc.id
#}
