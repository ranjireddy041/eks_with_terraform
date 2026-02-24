

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
  node_group_name = var.node_group_name
  subnet_ids = var.subnet_ids
  node_role_arn = var.node_role_arn
  capacity_type = var.capacity_type
    scaling_config {
    desired_size = var.desired_capacity
    max_size = var.max_size
    min_size = var.min_size
  } 
  instance_types = [var.instance_type]
  depends_on = [aws_eks_cluster.B12-cluster]
}


