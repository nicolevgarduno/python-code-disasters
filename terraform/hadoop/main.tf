# NameNode Deployment
resource "kubernetes_deployment" "namenode" {
  metadata {
    name      = "namenode"
    namespace = "default"
    labels = { app = "hadoop-namenode" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "hadoop-namenode" }
    }

    template {
      metadata {
        labels = { app = "hadoop-namenode" }
      }

      spec {
        container {
          name  = "namenode"
          image = "bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8"

          env {
            name  = "CLUSTER_NAME"
            value = "hadoop-cluster"
          }

           port {
            container_port = 9870
            name           = "ui"
          }
        }
      }
    }
  }
}

# NameNode Service
resource "kubernetes_service" "namenode" {
  metadata {
    name      = "namenode"
    namespace = "default"
  }

  spec {
    selector = { app = kubernetes_deployment.namenode.metadata[0].labels.app }
    port {
      port        = 9870
      target_port = 9870
      protocol    = "TCP"
      name        = "ui"
    }
    type = "LoadBalancer"
  }
}

# DataNode Deployment
resource "kubernetes_deployment" "datanode" {
  metadata {
    name      = "datanode"
    namespace = "default"
    labels = { app = "hadoop-datanode" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "hadoop-datanode" }
    }

    template {
      metadata {
        labels = { app = "hadoop-datanode" }
      }

      spec {
        container {
          name  = "datanode"
          image = "bde2020/hadoop-datanode:2.0.0-hadoop2.7.4-java8"

          env {
            name  = "CLUSTER_NAME"
            value = "hadoop-cluster"
          }

          port {
            container_port = 9864
            name           = "data"
          }
        }
      }
    }
  }
}

# ResourceManager Deployment
resource "kubernetes_deployment" "resourcemanager" {
  metadata {
    name      = "resourcemanager"
    namespace = "default"
    labels = { app = "hadoop-resourcemanager" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "hadoop-resourcemanager" }
    }

    template {
      metadata {
        labels = { app = "hadoop-resourcemanager" }
      }

      spec {
        container {
          name  = "resourcemanager"
          image = "bde2020/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8"

          env {
            name  = "CLUSTER_NAME"
            value = "hadoop-cluster"
          }

          port {
            container_port = 8088
            name           = "ui"
          }
        }
      }
    }
  }
}

# ResourceManager Service
resource "kubernetes_service" "resourcemanager" {
  metadata {
    name      = "resourcemanager"
    namespace = "default"
  }

  spec {
    selector = { app = kubernetes_deployment.resourcemanager.metadata[0].labels.app }
    port {
      port        = 8088
      target_port = 8088
      protocol    = "TCP"
      name        = "ui"
    }
    type = "LoadBalancer"
  }
}
