
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.dashboard.id
}

output "public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.dashboard.public_ip
}

output "dashboard_url" {
  description = "Dashboard URL"
  value       = "http://${aws_instance.dashboard.public_ip}:3000"
}


output "security_group_id" {
  description = "Security Group ID for temporary GitHub Actions SSH access"
  value       = aws_security_group.dashboard.id
}
