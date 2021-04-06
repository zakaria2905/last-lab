terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}
# ============   Provider Section   =================
provider "aws" {
  # profile = "default" # Authentication profile refers to ~/.aws/credentials
  
  #access_key = var.aws_access_key
  #secret_key = var.aws_secret_key
  
  region  = "us-east-2"
  
}

# ============   VPC Section   =================
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# ============   Keys  Section   =================
resource "aws_key_pair" "admin" {
  key_name   = "admin"
  public_key =  file("ssh-keys/id_rsa_aws.pub")   # file is a predefined terraform function 
}

# =================   EC2 Instance Secion =================
resource "aws_instance" "my-first-ec2-instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "admin"
}

# =================   Security Group Instance Secion =================
resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
  ingress {
    # TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "TCP"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Tous protocoles inclus
    cidr_blocks = ["0.0.0.0/0"]
  }

  resource "local_file" "inventory" {
    filename = "./hosts-generated"
    content     = <<EOF
    [my-ec2-instance]
    ${aws_instance.my-first-ec2-instance.public_ip}       

    EOF

}
