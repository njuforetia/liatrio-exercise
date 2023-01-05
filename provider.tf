provider "aws" {
  region = var.region
}


#terraform {
#  backend "s3" {
#    bucket = "cluster-state-bucket"
#    key    = "eks/state/terraform.tfstate"
#    region = "us-east-1"
#
#    dynamodb_table = "cluster-dynamodb-table"
#    encrypt        = true
#  }
#}


