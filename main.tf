terraform {
  required_providers {
    aws= {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
} 
resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role.name
}

module "vpc" {
  source = "./module/vpc"
  cidr_block = "10.81.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidr = ["10.81.1.0/24", "10.81.2.0/24", "10.81.3.0/24"] 
  private_subnet_cidr = ["10.81.4.0/24", "10.81.5.0/24", "10.81.6.0/24"] 
  cluster_name = var.cluster_name
  vpc_id = aws_vpc.eks_vpc.id
  
  
}

module "eks" {
  source = "./module/eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids = module.vpc.private_subnet_ids
  role_arn = var.role_arn
  vpc_id = module.vpc.vpc_id
  node_group = {
    default = {
      instance_type = var.instance_type
      capacity_type = var.capacity_type
      scaling_config = {
        desired_capacity = var.desired_capacity
        min_size = var.min_size
        max_size = var.max_size
      }
    }
  }


}
