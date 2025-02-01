resource "kubernetes_deployment" "auth" {
  metadata {
    name = "auth-php"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth-php"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth-php"
        }
      }

      spec {
        container {
          image = "${aws_ecr_repository.ecr_repos[0].repository_url}:latest"
          name  = "auth-php"
          port {
            container_port = 80
          }
          env_from {
            config_map_ref {
              name = "app-config"
            }
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "app-secrets"
                key  = "DB_PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}
