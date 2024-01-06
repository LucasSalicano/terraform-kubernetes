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