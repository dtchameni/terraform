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

resource "aws_vpc" "myapp-vpc" {
   cidr_block = var.vpc_cidr_block
   tags = {
      name: "${var.env_prefix}-vpc"
   }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    env_prefix = var.env_prefix
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
    source = "./modules/webserver"
    env_prefix = var.env_prefix
    avail_zone = var.avail_zone
    my_ip = var.my_ip
    instance_type = var.instance_type
    public_key_location = var.public_key_location
    vpc_id = aws_vpc.myapp-vpc.id
    subnet_id = module.myapp-subnet.subnet.id 

}


 
