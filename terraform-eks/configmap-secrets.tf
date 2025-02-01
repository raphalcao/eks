resource "kubernetes_config_map" "app_config" {
  metadata {
    name = "app-config"
  }

  data = {
    APP_ENV     = "production"
    APP_DEBUG   = "false"
    DB_HOST     = "mysql.auth.svc.cluster.local"
    DB_DATABASE = "auth"
    DB_USERNAME = "root"
  }
}

resource "kubernetes_secret" "app_secrets" {
  metadata {
    name = "app-secrets"
  }

  data = {
    DB_PASSWORD = "cGFzc3dvcmQ=" # Base64 de "password"
  }
}