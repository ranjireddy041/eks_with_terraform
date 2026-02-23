resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol = 
    cidr_blocks = [0
  }

resource "aws_eks_cluster" "B12-cluster" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}


resource "aws_eks_node_group" "node_group" {
  cluster_name = var.cluster_name
  node_group_name = var.node_group.node_group_name
  subnet_ids = var.subnet_ids
  node_role_arn = var.role_arn
  instance_types = var.node_group.instance_types
  capacity_type = var.node_group.capacity_type
    scaling_config {
    desired_size = var.node_group.scaling_config.desired_size
    max_size = var.node_group.scaling_config.max_size
    min_size = var.node_group.scaling_config.min_size
  } 
}


