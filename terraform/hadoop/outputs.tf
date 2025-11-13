output "namenode_endpoint" {
  value = kubernetes_service.namenode.status[0].load_balancer[0].ingress[0].ip
}

output "resourcemanager_endpoint" {
  value = kubernetes_service.resourcemanager.status[0].load_balancer[0].ingress[0].ip
}
