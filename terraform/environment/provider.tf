terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "tf-admin"
}

# We are configuring alias user just for practice purpose, we would not use it much heavily in this project!!
# provider "aws" {
#   alias   = "us-region"
#   region  = "us-west-1"
#   profile = "tf-user"
# }