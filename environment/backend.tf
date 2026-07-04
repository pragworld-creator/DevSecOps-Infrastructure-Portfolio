terraform {

  backend "s3" {
    bucket         = "aws-tfstate-file-bucket"
    key            = "tf-state-file/terraform.tfstate"
    region         = "eu-west-1"
    # dynamodb_table = "aws-tfstate-file-locking" /This is old method, no longer used in present deployment!
    use_lockfile   = true
    encrypt        = true
    profile      = "tf-admin"
  }
}

# This configuration allows you too store .tfstate file remote centrilized which will give advantage to work in developer environment without curropting state file and state locking mechanism.