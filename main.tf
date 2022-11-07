terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.37.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "subnet_cidr_block" {
    description = "subnet cidr block"
}

variable "vpc_cidr_block" {
    description = "vpc cidr block"
}

variable "environment" {
    description = "name of environment"
}

variable "availability_zone" {
    description = "name of availability zone"
}

resource "aws_vpc" "development-vpc" {
   cidr_block = var.vpc_cidr_block
   tags = {
      name: "devlopment-vpc",
      terraform: "true",
      Environment: var.environment
   }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    tags = {
      name: "subnet-1-dev",
      terraform: "true"
      environment: var.environment
   }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.96.0/20" 
    availability_zone = "us-east-1b"
    tags = {
       name = "subnet-1-dev",
       terraform: "true"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}