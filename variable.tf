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
  description = "eks node group configuration"
  type =map(object({
    instance_type   = list(string)
    capacity_type   = string
    scaling_config = object({
    desired_capacity = number
    min_size       = number
    max_size       = number
  }) 
  }))
  default = {
    "general" = {
      instance_type = ["m7i-flex.large"]
      capacity_type = "ON_DEMAND"
      scaling_config = {
        desired_capacity = 2
        min_size       = 1
        max_size       = 3
      }
    }
  } 
}
