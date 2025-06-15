terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    
    required_version = ">=1.3.0"
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = [".secrets/credentials"]
    profile = "default"
}

data "aws_ami" "app_ami_coco" {
  most_recent = true
  owners      = ["amazon"]
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

resource "aws_instance" "myec2" {
    ami           =  data.aws_ami.app_ami_coco.id
    instance_type = var.instance_type
    key_name      = "devops-coco" 
    tags = var.aws_common_tag
    security_groups = [ aws_security_group.allow_http_https_ssh.name]
}

resource "aws_security_group" "allow_http_https_ssh" {
    name = "coco-tp3-sg"
    description = "Allow HTTP, HTTPS and SSH traffic"

    ingress  {
        description = "TLS from VPC"
        from_port   = 443
        to_port     = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
        description = "SSH from VPC"
        from_port   = 22
        to_port     = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress  {
        description = "HTTP from VPC"
        from_port   = 80
        to_port     = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        description = "Allow all outbound traffic from vpc"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 
  
}

resource "aws_eip" "load_balancer_eip" {
    instance = aws_instance.myec2.id
  
}