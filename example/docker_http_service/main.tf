# create by https://harshitdawar.medium.com/launching-a-vpc-with-public-private-subnet-in-aws-using-terraform-191188e6cad4

# ec2 configuration
resource "aws_instance" "demo_ec2" {

  depends_on = [
    aws_vpc.demo_vpc,
    aw_subnet.public_subnet,
    aws_subnet.private_subnet,
    aws_security_group.normal_rule,
  ]

  # AMI ID [I have used my custom AMI which has some softwares pre installed]
  # ami                    = var.ami_id

  ami           = data.aws_ami.amazon-linux-2.id
  count         = var.number_of_instances
  instance_type = var.instance_type
  #subnet_id              = var.subnet_id
  subnet_id = aws_subnet.public_subnet.id

  key_name = var.ami_key_pair_name

  # Security group ID's
  vpc_security_group_ids = [aws_security_group.normal_rule.id]

  tags = {
    Name        = "Webserver_From_Terraform"
    Terraform   = "true"
    Environment = "dev"
    # Environment   = "production"
  }

  # Installing required softwares into the system!
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./my-key-pair.pem")
    host        = aws_instance.demo_ec2[0].public_ip
  }
  # associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install docker
                sudo service docker start
                sudo usermod -a -G docker ec2-user
                EOF

  #provisioner "file" {
  #  source = "my-image.tar.gz"
  #  destination = "/home/ec2-user/my-image.tar.gz"
  #}

  # Code for installing the softwares!
  provisioner "remote-exec" {
    inline = [
      "docker run -d --restart=always  -p 80:8080 public.ecr.aws/w3s2d0z8/normal-playwright-api:master",
    ]
  }
}
