# Write a script to launch resources on the cloud

# Create EC2 instance on AWS
# syntax {
#         ami= ami_id}
# Download dependecies from AWS
provider "aws" {

# Which part of AWS we would like to launch resources in
  region = "eu-west-1"

}
resource "aws_instance" "app_instance" {
  ami = "ami-0b47105e3d7fc023e"
  instance_type = "t2.micro"
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
