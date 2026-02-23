resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port   = 22
    to_port     = 22
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
    from_port = 8080
    to_port   = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.cluster_name}-vpc"
  }    
}
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.cluster_name}-public-subnet-${count.index}"
    }
}
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.cluster_name}-private-subnet-${count.index}"
    }
}