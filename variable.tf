variable "AWS_REGION" {
  description = "AWS region to deploy resources"
  type        = string
  default = "us-east-1"
}
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}
variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}
variable "cidr_block" {
  default = "10.81.0.0/16"
}
variable "vpc_id" {
  default = "${cidr_block}"
}
variable "availability_zones" {
  description = "availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "private_subnet_cidr" {
  description = "private subnet cidr"
  type = list(string)
  default = ["10.81.1.0/24", "10.81.2.0/24", "10.81.3.0/24"]
}
variable "public_subnet_cidr" {
  description = "public subnet cidr"
  type = list(string)
  default = ["10.81.4.0/24", "10.81.5.0/24", "10.81.6.0/24"]
}
variable "cluster_name" {
  type    = string
  default = "B12-eks-cluster"
}
variable "cluster_version" {
  description = "version of the cluster"
  type = string
  default = "1.30"
}

variable "node_group" {
  type = string
  
}
variable "instance_type" {
  default = "t3.medium"
}
variable "capacity_type" {
  default = "ON_DEMAND"
}
variable "desired_capacity" {
  default = "2"
}
variable "min_size" {
  default = "1"
}
variable "max_size" {
  default = "3"
}
variable "role_arn" {
  default = "aws_iam_role.eks_cluster_role.arn"
}