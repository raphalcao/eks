resource "aws_ecr_repository" "ecr_repos" {
  count = length(var.ecr_repositories)
  name  = var.ecr_repositories[count.index]
}