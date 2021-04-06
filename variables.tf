variable "aws_region" {}
variable "aws_profile" {}
variable "account_id" {}
variable "global_environment" {
  type        = string
  description = "Tag for application environment (dev, uat, sit, prod, etc)"
}

variable "runtime" {
  default     = "python3.8"
  type        = string
  description = "Python runtime environment/version for the lambda function"
}
variable "childplay_alexa_lambda_timeout" {
  default     = 30
  type        = number
  description = "Time from execution in seconds that the lambda will timeout."
}

variable "cloudwatch_logs_retention_period" {
  default     = 30
  type        = number
  description = "The number of days to retain log events of the lambda function"
}

variable "global_product" {
  type        = string
  description = "Tag for product the resource is used by)"
}

variable "global_orchestration" {
  type        = string
  description = "Source that created resource normally git repo"
}

variable "global_costcode" {
  type        = string
  description = "The costcentre code to tag"
}

variable "global_contact" {
  type        = string
  description = "The contact label to tag resources"
}

variable "global_subproduct" {
  type        = string
  description = "Assigned in design phase. Used where an AWS account runs more than one service (eg: finance account runs SubProduct tags would be defined for these services). Mandatory for resource type 3 IF multiple subproducts are to be defined for an account"
}
