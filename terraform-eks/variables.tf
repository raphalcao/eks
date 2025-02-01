variable "cluster_name" {
  default = "my-cluster"
}

variable "ecr_repositories" {
  type    = list(string)
  default = ["auth-php", "processing-php"]
}

variable "github_repositories" {
  type = map(string)
  default = {
    "auth"       = "https://github.com/raphalcao/auth.git"
    "processing" = "https://github.com/raphalcao/processing.git"
  }
}