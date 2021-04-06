
terraform {
  backend "s3" {
    bucket  = "elsevier-tio-109026305461"
    key     = "terraform/dapinder/alexa_childplay/terraform.tfstate"
    region  = "eu-west-1"
    profile = "aws-bts-training"
    encrypt = true
  }
}
