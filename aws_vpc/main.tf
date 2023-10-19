terraform {
  required_version = ">1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">5.8.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}



module "aws_vpc" {
  source = "/root/aws_vpc/vpc"
}
