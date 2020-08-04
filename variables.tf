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

# LB Vars
variable "health_check_grace_period_seconds" {

  description = "Seconds to ignore failing load balancer health checks."
  type        = number
  default     = 0
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

variable "placement_strategy" {
  description = "Mapping from service to strategy."

  type = list(object({
    type  = string
    field = string
  }))
  default = []
}

variable "max_capacity" {
  description = "Max Capacity of tasks ECS Service"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Min Capacity of tasks ECS Service"
  type        = number
  default     = 1
}

variable "resource_id" {
  description = "Ecs Service name"
  type        = string
  default     = ""
}

variable "service_namespace" {
  description = "Service Name Space"
  type        = string
  default     = "ecs"
}

variable "scalable_dimension" {
  description = "Scalable dimension"
  type        = string
  default     = "ecs:service:DesiredCount"
}

variable "policy_type" {
  description = "App autoscaling Policy type"
  type        = string
  default     = "TargetTrackingScaling"
}

variable "target_value" {
  description = "Target Value of app autoscaling target"
  type        = number
  default     = 65
}

variable "scale_in_cooldown" {
  description = "Scale in cool down of App Autoscaling Target"
  type        = number
  default     = 60
}

variable "scale_out_cooldown" {
  description = "Scale out cool down of App Autoscaling Target"
  type        = number
  default     = 30
}

variable "name_policy" {
  description = "Name auto scaling policy"
  type        = string
  default     = ""
}
