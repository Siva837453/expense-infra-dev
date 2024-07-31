terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.49.0"
    }
  }
    backend "s3" {
    bucket = "siva-remote-state"
    key    = "Expense-dev-db"
    region = "us-east-1"
    dynamodb_table = "remote-lockid"
 }

}

# aws Configuration 
provider "aws" {
    region = "us-east-1"
}
