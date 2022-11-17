provider "aws" {
  region = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "eng130-angel-terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "eng130-angel-terraform-vpc"
  }
}

# Create Subnet 10.0.6.0/24 for public - 10.0.18.0/24 for prvate
resource "aws_subnet" "eng130-angel-terraform-subnet" {
  vpc_id     = aws_vpc.eng130-angel-terraform-vpc.id
  cidr_block = "10.0.6.0/24"
  tags = {
    "Name" = "eng130-angel-terraform-subnet"
  }
}

# Create Security Group for instance
resource "aws_security_group" "eng130-angel-terraform-sg" {
  name   = "eng130-angel-terraform-sg"
  vpc_id = aws_vpc.eng130-angel-terraform-vpc.id
  # Inbound Rules

  # SSH from anywhere
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eng130-angel-terraform-sg"
  }

}

# Create Internet Gateway
resource "aws_internet_gateway" "eng130-angel-terraform-ig" {
  vpc_id = aws_vpc.eng130-angel-terraform-vpc.id
  tags = {
    Name = "eng130-angel-terraform-ig"
  }
}

# Create Route Table
resource "aws_route_table" "eng130-angel-terraform-rt" {
  vpc_id = aws_vpc.eng130-angel-terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eng130-angel-terraform-ig.id
  }

  tags = {
    Name = "eng130-angel-terraform-rt"
  }
}

# Create RT association
resource "aws_main_route_table_association" "eng130-angel-terraform-rta" {
  vpc_id         = aws_vpc.eng130-angel-terraform-vpc.id
  route_table_id = aws_route_table.eng130-angel-terraform-rt.id
}


# Create app instance
resource "aws_instance" "eng130-angel-terraform-app" {
  ami                         = var.webapp-ami-id # "ami-0b47105e3d7fc023e"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.eng130-angel-terraform-sg.id]
  subnet_id                   = aws_subnet.eng130-angel-terraform-subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "eng130-angel-terraform-app"
  }
}
# What type of server with what sort of functionality

# Add resource

# AMI

# Instance type

# Do we need public IP or not

# Name the server
