terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

resource "null_resource" "apply_sonarqube_manifests" {
  triggers = {
    manifests_hash = join("", [
      filesha256("${path.module}/manifests/00-namespace.yaml"),
      filesha256("${path.module}/manifests/01-monitoring-secret.yaml"),
      filesha256("${path.module}/manifests/02-postgres-deployment.yaml"),
      filesha256("${path.module}/manifests/03-postgres-service.yaml"),
      filesha256("${path.module}/manifests/10-sonarqube-deployment.yaml"),
      filesha256("${path.module}/manifests/11-sonarqube-service.yaml")
    ])
  }

  provisioner "local-exec" {
    command = <<EOT
set -e
echo "Applying Kubernetes manifests..."
kubectl apply -f ${path.module}/manifests/00-namespace.yaml
kubectl apply -f ${path.module}/manifests/01-monitoring-secret.yaml
kubectl apply -f ${path.module}/manifests/02-postgres-deployment.yaml
kubectl apply -f ${path.module}/manifests/03-postgres-service.yaml
kubectl apply -f ${path.module}/manifests/10-sonarqube-deployment.yaml
kubectl apply -f ${path.module}/manifests/11-sonarqube-service.yaml
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
