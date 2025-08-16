provider "aws" {
  region = var.aws_region
}

# Security Group
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSHAccess"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.ssh_access.name]

  tags = {
    Name = "Terraform-EC2"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name

  tags = {
    Name = "TerraformBucket"
  }
}
