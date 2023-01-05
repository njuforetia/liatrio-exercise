#provider "aws" {
#  region = var.region
#}

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket = "cluster-state-bucket"
    key    = "eks/state/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "cluster-dynamodb-table"
    encrypt        = true
  }
}


# terraform {
#   backend "s3" {
#     bucket = "web-cluster-s3-bucker"
#     key    = "eks/state/terraform.tfstate"
#     region = "us-east-1"

#     dynamodb_table = "web-cluster-s3-bucker"
#     encrypt        = true
#   }
# }