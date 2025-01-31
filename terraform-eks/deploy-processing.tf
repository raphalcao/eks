resource "kubernetes_deployment" "processing" {
  metadata {
    name = "processing-php"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "processing-php"
      }
    }

    template {
      metadata {
        labels = {
          app = "processing-php"
        }
      }

      spec {
        container {
          image = "${aws_ecr_repository.ecr_repos[1].repository_url}:latest"
          name  = "processing-php"
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