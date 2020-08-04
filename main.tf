resource "aws_ecs_service" "main" {
  name                              = var.service_name
  cluster                           = var.ecs_cluster_id
  task_definition                   = var.ecs_task_definition_arn
  desired_count                     = var.service_desired_count
  iam_role                          = var.ecs_service_role
  launch_type                       = var.service_launch_type
  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = var.lb_target_groups_map

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }

  }

  dynamic "network_configuration" {
    for_each = var.awsvpc_service_map

    content {
      security_groups = network_configuration.value.security_groups
      subnets         = network_configuration.value.subnets
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.placement_strategy


    content {
      type  = ordered_placement_strategy.value.type
      field = ordered_placement_strategy.value.field
    }
  }


  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  count = var.service_launch_type == "EC2" ? 1 : 0

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.resource_id
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
}

resource "aws_appautoscaling_policy" "appautoscaling_policy_rpm_scale_up" {
  count = var.service_launch_type == "EC2" ? 1 : 0

  name               = var.name_policy
  resource_id        = var.resource_id
  policy_type        = var.policy_type
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}
