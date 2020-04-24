output "desired_count" {
  description = "The number of instances of the task definition to place and keep running."
  value       = aws_ecs_service.main.desired_count
}
