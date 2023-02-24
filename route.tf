##
## vpc/subnet configuration
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  # Enabling automatic hostname assigning
  enable_dns_hostnames = true
  tags = {
      Name = "terraform"
    }
}


##
## Create a Public Subnet with auto public IP Assignment enabled in demo VPC!
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.demo_vpc
  ]

  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.demo_vpc.id

  # IP Range of this subnet
  cidr_block = "10.0.1.0/24"

  # Data Center of this subnet.
  availability_zone = "us-east-1a"

  # Enabling automatic public IP assignment on instance launch!
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

##
## Create a Private Subnet in demo VPC!
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.demo_vpc,
    aws_subnet.public_subnet
  ]
  
  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.demo_vpc.id
  
  # IP Range of this subnet
  cidr_block = "10.0.0.0/24"
  
  # Data Center of this subnet.
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "Private Subnet"
  }
}

##
## Creating an Internet Gateway for the VPC
resource "aws_internet_gateway" "Internet_Gateway" {
  depends_on = [
    aws_vpc.demo_vpc,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet
  ]
  
  # VPC in which it has to be created!
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "Demo-Public-&-Private-VPC"
  }
}

##
## Creating an Route Table for the public subnet!
resource "aws_route_table" "Public-Subnet-RT" {
  depends_on = [
    aws_vpc.demo_vpc,
    aws_internet_gateway.Internet_Gateway
  ]

   # VPC ID
  vpc_id = aws_vpc.demo_vpc.id

  # NAT Rule
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}

##
## Creating a resource for the Route Table Association!
resource "aws_route_table_association" "RT-IG-Association" {

  depends_on = [
    aws_vpc.demo_vpc,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet,
    aws_route_table.Public-Subnet-RT
  ]

# Public Subnet ID
  subnet_id      = aws_subnet.public_subnet.id

#  Route Table ID
  route_table_id = aws_route_table.Public-Subnet-RT.id
}
