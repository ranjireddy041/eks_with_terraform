terraform {
  required_providers {
    aws= {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  
  source = "./module/vpc"

  cidr_block = var.cidr_block
  availability_zones = var.availability_zones
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
  cluster_name = var.cluster_name
}

module "eks" {
  
  source = "./module/eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  node_group = var.node_group
}