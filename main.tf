# Write a script to launch resources on the cloud

# Create EC2 instance on AWS
# syntax {
#         ami= ami_id}
# Download dependecies from AWS
provider "aws" {

# Which part of AWS we would like to launch resources in
  region = "eu-west-1"

}
resource "aws_instance" "app_instance"{
  ami = var.webapp-ami-id# "ami-0b47105e3d7fc023e"
  instance_type = "t2.micro"
  key_name = "eng130"
  associate_public_ip_address = true
  tags = {
    Name = "eng130-angel-terraform-app"
  }
}
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  id = "eng130-angel-terraform-vpc"
  tags = {
    Name = "eng130-angel-terraform-vpc"
  }
}
resource "aws_subnet" "custom_subnet" {
  vpc_id = aws_vpc.custom_vpc
  cidr_block = "10.0.6.0/24"
  tags = {
    "Name" = "eng130-angel-terraform-subnet"
  }
}
resource "aws_security_group" "custom_security_group" {
  
}
# What type of server with what sort of functionality

# Add resource

# AMI

# Instance type

# Do we need public IP or not

# Name the server
