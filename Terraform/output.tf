output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}
