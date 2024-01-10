terraform {
    required_version = ">=0.13.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
    source = "./modules/vpc"
    prefix = var.prefix
    vpc_cidr_block = var.vpc_cidr_block
}

module "eks" {
    source = "./modules/eks"
    prefix = var.prefix
    vpc_id = module.vpc.vpc_id
    cluster_name = var.cluster_name
    retetion_in_days = var.retetion_in_days
    subnets_id = module.vpc.subnets_id
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
}
