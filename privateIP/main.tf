variable "aws_access_key" {
        description = "Access key to AWS console"
}
variable "aws_secret_key" {
        description = "Secret key to AWS console"
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

##############
# define ec2

resource "aws_instance" "private_ec2_demo" {
  depends_on = [
      aws_subnet.private_subnet,
      aws_security_group.normal_rule_1,
      aws_network_interface.private_ip
  ]
  # ami          = "ami-0c55b159cbfafe1f0"
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.nano"
  key_name      = "my-key-pair"
  count         = 1
  # "network_interface": conflicts with vpc_security_group_ids
  #vpc_security_group_ids = ["$(aws_security_group.private_subnet.id)"]

  network_interface {
    network_interface_id = aws_network_interface.private_ip.id
    #security_groups = ["${aws_security_group.normal_rule_1.id}"]
    device_index         = 0
  }
  tags = {
        Name          = "private_ec2_demo"
        Terraform     = "true"
        Environment   = "dev"
        # Environment   = "production"
    }
}

resource "aws_vpc" "private_vpc" {
  cidr_block = "10.0.0.0/16"
  # Enabling automatic hostname assigning
  enable_dns_hostnames = true
  tags = {
      Name = "terraform"
    }
}

resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.private_vpc
  ]
  vpc_id            = "${aws_vpc.private_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}


resource "aws_security_group" "normal_rule_1" {
  depends_on = [
    aws_vpc.private_vpc,
    aws_subnet.private_subnet
  ]

  description = "HTTP, PING, SSH"
  name = "normal_port_enable"

  # Created an inbound rule for ping
  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Created an inbound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outward Network Traffic
  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "private_ip" {
  depends_on = [
      aws_subnet.private_subnet,
  ]
  subnet_id = aws_subnet.private_subnet.id

  private_ips = [
    "10.0.1.10"  # replace as your private ip
  ]
  #security_groups = [
  #    "${aws_security_group.normal_rule_1.id}"
  #  ]
}
