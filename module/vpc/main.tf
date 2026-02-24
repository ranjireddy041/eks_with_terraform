resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-eks-sg"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.this.id

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
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block   
}
resource "aws_eip" "eks_cluster_eip" {
  domain = "vpc"
  
}
resource "aws_route_table" "private_Rt" {
  vpc_id = aws_vpc.this.id 

  tags = {
    Name = "${var.cluster_name}-private-rt"
  } 
}

resource "aws_route_table" "public_Rt" {
  vpc_id = aws_vpc.this.id 

  tags = {
    Name = "${var.cluster_name}-public-rt"
  } 
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_Rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.eks-NG.id
}

resource "aws_route_table_association" "private_assoc" {
  count = length(var.private_subnet_cidr)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_Rt.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_Rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.eks-igw.id
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.cluster_name}-internet-gateway"
  }
}
resource "aws_nat_gateway" "eks-NG" {
  allocation_id = aws_eip.eks_cluster_eip.id
  subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.cluster_name}-nat-gateway"
}
  depends_on = [aws_internet_gateway.eks-igw]
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.cluster_name}-public-subnet-${count.index}"
    }
}
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.cluster_name}-private-subnet-${count.index}"
    }
}