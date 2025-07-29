output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres_db.endpoint
}

output "ecs_service_name" {
  value = aws_ecs_service.java_app_service.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.java_app_cluster.name
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.java_app.arn
}
output "ecs_service_url" {
  description = "URL of the ECS service"
  value       = "http://${aws_lb.app_alb.dns_name}"
}