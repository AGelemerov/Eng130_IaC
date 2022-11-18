
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
resource "aws_route_table_association" "eng130-angel-terraform-rta" {
  # vpc_id         = aws_vpc.eng130-angel-terraform-vpc.id
  subnet_id      = aws_subnet.eng130-angel-terraform-subnet.id
  route_table_id = aws_route_table.eng130-angel-terraform-rt.id
}

resource "aws_lb" "eng130-angel-terraform-lb" {
  name               = "eng130-angel-terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eng130-angel-terraform-sg.id]
  subnets            = [aws_subnet.eng130-angel-terraform-subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
    Name = "eng130-angel-terraform-lb"
  }
}
# Create app instance
resource "aws_instance" "eng130-angel-terraform-controller" {
  ami                         = var.webapp-ami-id # "ami-0b47105e3d7fc023e"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.eng130-angel-terraform-sg.id]
  subnet_id                   = aws_subnet.eng130-angel-terraform-subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "eng130-angel-terraform-controller"
  }
}

resource "aws_launch_template" "eng130-angel-terraform-lt" {
  name = "eng130-angel-terraform-lt"
  image_id = "ami-0eb28d325ae047a58"
  instance_initiated_shutdown_behavior = "terminate"
  instance_market_options {
    market_type = "spot"
  }
  instance_type = "t2.micro"
  key_name = "eng130-new"

  monitoring {
    enabled = false
  }
  network_interfaces {
    associate_public_ip_address = true
  }
  placement {
    availability_zone = "eu-west-1"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eng130-angel-terraform-app"
    }
  }
  # vpc_security_group_ids = [aws_security_group.eng130-angel-terraform-sg.id]
  user_data = filebase64("${path.module}/provision.sh")
}

resource "aws_autoscaling_group" "eng130-angel-terraform-asg" {
  name                      = "eng130-angel-terraform-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.eng130-angel-terraform-subnet.id]
  launch_template {
    id = aws_launch_template.eng130-angel-terraform-lt.id
  }
}
