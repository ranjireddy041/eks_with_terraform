variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "role_arn" {
  type = string
}

variable "node_group_name" {
 type = string
}

variable "instance_type" {
  type = string
}
variable "capacity_type" {
  type = string
}
variable "desired_capacity" {
  type = string
  
}
variable "min_size" {
  type = string
  
}
variable "max_size" {
  type = string
  
}