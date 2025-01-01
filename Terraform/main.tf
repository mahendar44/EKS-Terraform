provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_a_cidr_block
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_b_cidr_block
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      }
    ]
  })
}

resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "eks-cluster-policy"
  description = "EKS cluster policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:*"
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "main" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_a.id,
      aws_subnet.subnet_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy
  ]
}

resource "aws_iam_role" "node_group_role" {
  name = "eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      }
    ]
  })
}

resource "aws_iam_policy" "node_group_policy" {
  name        = "eks-node-group-policy"
  description = "Node group policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2:*"
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_role_policy" {
  policy_arn = aws_iam_policy.node_group_policy.arn
  role       = aws_iam_role.node_group_role.name
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  instance_types = var.node_group_instance_types

  ami_type = "AL2_x86_64"

  depends_on = [
    aws_iam_role_policy_attachment.node_group_role_policy
  ]
}

