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
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

module "vpc" {
  source = "./module/vpc"
  cluster_name = var.cluster_name
  cidr_block = var.cidr_block
  availability_zones = var.availability_zones
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr


}

module "eks" {
  source = "./module/eks"
  vpc_id = module.vpc.vpc_id
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = module.vpc.private_subnet_ids
  node_group_name = "${var.cluster_name}-node-group"
  instance_type = var.instance_type
  capacity_type = var.capacity_type
  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.max_size
  
}
