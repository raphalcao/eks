output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "ecr_repository_auth" {
  value = aws_ecr_repository.ecr_repos[0].repository_url
}

output "ecr_repository_processing" {
  value = aws_ecr_repository.ecr_repos[1].repository_url
}
