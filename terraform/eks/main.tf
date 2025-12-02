provider "aws" { region = "ap-south-1" }

# This is a placeholder. Replace with your preferred EKS module or custom resources.
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "poc-eks-cluster"
  cluster_version = "1.28"
  subnets         = ["subnet-xxxxx", "subnet-yyyyy"]
  vpc_id          = "vpc-xxxxx"
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}