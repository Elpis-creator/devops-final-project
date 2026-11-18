
terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "sivanna-devops"

    workspaces {
      name = "devops-final-project"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "dashboard" {
  name_prefix = "devops-dashboard-"
  description = "Security group for DevOps Dashboard"

  ingress {
    description = "SSH from authorized IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description = "Dashboard from authorized IP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "devops-dashboard-sg"
    Project = "devops-final-project"
  }
}

resource "aws_instance" "dashboard" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.dashboard.id]

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
  }

  user_data = replace(<<-EOF
    #!/bin/bash
    set -eux

    apt-get update
    apt-get install -y docker.io docker-compose-v2

    systemctl enable --now docker
    usermod -aG docker ubuntu

    touch /var/tmp/docker-ready
  EOF
  , "\r\n", "\n")


  tags = {
    Name    = "devops-final-dashboard"
    Project = "devops-final-project"
  }
}
