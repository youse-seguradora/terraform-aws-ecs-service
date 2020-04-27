output "desired_count" {
  description = "The number of instances of the task definition to place and keep running."
  value       = aws_ecs_service.main.desired_count
}

output "name" {
  description = "The name of ECS Service."
  value       = aws_ecs_service.main.name
}
