output "alb_public_dns_name" {
  description = "The public DNS name of the Application Load Balancer"
  value       = "http://${module.compute.alb_dns_name}"
}