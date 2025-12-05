terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60.0, < 6.0.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

# --------------------------
# Availability Zones
# --------------------------
data "aws_availability_zones" "available" {}

# # --------------------------
# # ECR Repository
# # --------------------------
# resource "aws_ecr_repository" "node_repo" {
#   name                 = var.ecr_repo_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = var.tags
# }

# --------------------------
# VPC (UPDATED MODULE)
# --------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = var.tags
}

# --------------------------
# EKS Cluster (MODERN SYNTAX )
# --------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.project}-eks"
  cluster_version = var.k8s_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }

  tags = var.tags
}

# --------------------------
# Outputs
# --------------------------
output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "cluster_name" {
  value = module.eks.cluster_name
}

# output "ecr_repo_url" {
#   value = aws_ecr_repository.node_repo.repository_url
# }
