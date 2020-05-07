# AWS Terraform module to create Fargate / ECS service

This modules creates a Fargate or ECS service optionally with a application load balancer.

- Supports network modes: "awsvpc" and "bridge"
- Supports ECS and FARGATE

## Example usages

Below an example for deloy a service to Fargate. See the example directroy for more and complete examples.

```hcl
local {

  ecs_cluster_id = arn:aws:ecs:us-east-1:123123123123:cluster/nginx
  app_name       = nginx
  app_port       = 8080

}

module "ecs_service" {
  source = "github.com/youse_seguradora/terraform-aws-ecs-service"

  service_name          = local.app_name
  service_launch_type   = "FARGATE"
  service_desired_count = 1

  ecs_cluster_id          = "arn:aws:ecs:us-east-1:123123123123:cluster/core"
  ecs_task_definition_arn = module.ecs_task_definition.arn

  enable_lb = true

  awsvpc_service_map = [{
    security_groups = ["sg-asdqwe123"].
    subnets         = ["subnet-asdqwe123", "subnet-asdqwe456"]
  }]

  lb_target_groups_map = [{
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = local.app_name
    container_port   = local.app_port
  }]
}
```

## Testing

### To run all test

```bash
cd test/
go test
```

:warning: Running the test may result in an AWS charge.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.24 |
| aws | ~> 2.58 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.58 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| awsvpc\_service\_map | Mapping awsvpc required attributes to network\_configuration. | <pre>list(object({<br>    security_groups = list(string)<br>    subnets         = list(string)<br>  }))</pre> | `[]` | no |
| ecs\_cluster\_id | The id of the ECS cluster | `string` | n/a | yes |
| ecs\_service\_role | IAM role to attach to service | `string` | `""` | no |
| ecs\_task\_definition\_arn | The AWS task definition of the containers to be created. | `string` | n/a | yes |
| enable\_lb | Enable or disable the load balancer. | `bool` | `false` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks. | `number` | `60` | no |
| lb\_target\_groups\_map | Mapping from service to targets groups. | <pre>list(object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = number<br>  }))</pre> | `[]` | no |
| service\_desired\_count | The number of instances of the task definition to place and keep running. | `number` | `1` | no |
| service\_launch\_type | The launch type, can be EC2 or FARGATE. | `string` | `"EC2"` | no |
| service\_name | Logical name of the service. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| desired\_count | The number of instances of the task definition to place and keep running. |
| name | The name of ECS Service. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Youse Seguradora](https://github.com/youse-seguradora).

## License

Apache 2 Licensed. See LICENSE for full details.