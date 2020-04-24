# Service for awsvpc networking and ALB/NLB
resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = var.ecs_task_definition_arn
  desired_count   = var.service_desired_count
  iam_role        = var.ecs_service_role
  launch_type     = var.service_launch_type

  dynamic "load_balancer" {
    for_each = var.enable_lb ? [var.lb_target_groups_map] : []

    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = load_balancer.value["container_name"]
      container_port   = load_balancer.value["container_port"]
    }

  }

  dynamic "network_configuration" {
    for_each = var.service_launch_type == "FARGATE" ? [var.awsvpc_service_map] : []

    content {
      security_groups = network_configuration.value["security_groups"]
      subnets         = network_configuration.value["subnets"]
    }
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
