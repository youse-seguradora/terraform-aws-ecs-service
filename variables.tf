variable "service_name" {
  description = "Logical name of the service."
  type        = string
}

variable "ecs_cluster_id" {
  description = "The id of the ECS cluster"
  type        = string
}

variable "ecs_task_definition_arn" {
  description = "The AWS task definition of the containers to be created."
  type        = string
}

variable "service_desired_count" {
  description = "The number of instances of the task definition to place and keep running."
  type        = number
  default     = 1
}

variable "ecs_service_role" {
  description = "IAM role to attach to service"
  type        = string
  default     = ""
}

variable "service_launch_type" {

  description = "The launch type, can be EC2 or FARGATE."
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period_seconds" {

  description = "Seconds to ignore failing load balancer health checks."
  type        = number
  default     = 0
}

# LB Vars
variable "enable_lb" {
  type        = bool
  description = "Enable or disable the load balancer."
  default     = false
}

variable "lb_target_groups_map" {
  description = "Mapping from service to targets groups."

  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  default = []
}

#Network AWSVPC Vars
variable "awsvpc_service_map" {
  description = "Mapping awsvpc required attributes to network_configuration."

  type = list(object({
    security_groups = list(string)
    subnets         = list(string)
  }))
  default = []
}
