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
variable "node_group" {
  type = string
}

variable "role_arn" {
  type = string
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
}
