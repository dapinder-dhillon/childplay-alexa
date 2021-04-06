# pins TF and its providers to specific versions

terraform {
  required_version = "=0.13.4"
  required_providers {
    aws = ">=3.21.0"
  }
}
