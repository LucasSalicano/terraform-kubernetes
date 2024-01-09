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
