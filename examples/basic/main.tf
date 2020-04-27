provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "github.com/youse-seguradora/terraform-aws-vpc"

  name = var.vpc_name

  cidr = "192.168.253.0/24"

  azs                    = ["us-east-2a"]
  compute_public_subnets = ["192.168.253.0/24"]
}

module "ecs_cluster" {
  source = "github.com/youse-seguradora/terraform-aws-ecs-cluster"

  ecs_cluster_name = var.ecs_cluster_name
}

module "ecs_fargate_task_def" {
  source = "github.com/youse-seguradora/terraform-aws-ecs-task-definition"

  name                     = var.app_name
  container_definitions    = file("task.json")
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

module "ecs_service" {
  source = "../.."

  service_name          = var.app_name
  service_launch_type   = "FARGATE"
  service_desired_count = 1

  ecs_cluster_id          = module.ecs_cluster.cluster_id
  ecs_task_definition_arn = module.ecs_fargate_task_def.arn

  awsvpc_service_map = [{
    security_groups = [module.vpc.default_security_group_id]
    subnets         = module.vpc.public_subnets
  }]
}

variable "vpc_name" {
  default = "test_ecs_service"
}
variable "ecs_cluster_name" {
  default = "test_ecs_service"
}
variable "app_name" {}


output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}
output "ecs_fargate_task_def_arm" {
  value = module.ecs_fargate_task_def.arn
}
output "vpc_security_group_id" {
  value = module.vpc.default_security_group_id
}
output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}
output "desired_count" {
  value = module.ecs_service.desired_count
}

output "app_name" {
  value = module.ecs_service.name
}
