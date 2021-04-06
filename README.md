# childplay-alexa
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | =0.13.4 |
| aws | >=3.21.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_id | n/a | `any` | n/a | yes |
| aws_profile | n/a | `any` | n/a | yes |
| aws_region | n/a | `any` | n/a | yes |
| childplay_alexa_lambda_timeout | Time from execution in seconds that the lambda will timeout. | `number` | `30` | no |
| cloudwatch_logs_retention_period | The number of days to retain log events of the lambda function | `number` | `30` | no |
| global_contact | The contact label to tag resources | `string` | n/a | yes |
| global_costcode | The costcentre code to tag | `string` | n/a | yes |
| global_environment | Tag for application environment (dev, uat, sit, prod, etc) | `string` | n/a | yes |
| global_orchestration | Source that created resource normally git repo | `string` | n/a | yes |
| global_product | Tag for product the resource is used by) | `string` | n/a | yes |
| global_subproduct | Assigned in design phase. Used where an AWS account runs more than one service (eg: finance account runs SubProduct tags would be defined for these services). Mandatory for resource type 3 IF multiple subproducts are to be defined for an account | `string` | n/a | yes |
| runtime | Python runtime environment/version for the lambda function | `string` | `"python3.8"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
