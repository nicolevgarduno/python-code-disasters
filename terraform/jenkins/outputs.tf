data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "default"
  }

  depends_on = [helm_release.jenkins]
}

output "jenkins_endpoint" {
  value = try(
    data.kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].ip,
    "pending"
  )
}
