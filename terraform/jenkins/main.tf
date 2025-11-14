# Get info about your existing cluster
data "google_container_cluster" "project_cluster" {
  name     = "standard-cluster"
  location = "us-east4"
  project  = var.project_id
}

data "google_client_config" "default" {}

# Deploy Jenkins Helm chart to the default node pool (no extra node pool resource)
resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "default"
  version    = "5.8.110" # stable chart version

  values = [
    file("${path.module}/jenkins-values.yaml")
  ]

  depends_on = [
    data.google_container_cluster.project_cluster
  ]
}
