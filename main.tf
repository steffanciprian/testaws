provider "aws" {
  region = "eu-west-1"
}

provider "github" {
  # Configuration options
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.0.0-rc1"
    }
  }
}

resource "null_resource" "terraform_start_message" {
  provisioner "local-exec" {
    command = "echo 'Starting Terraform for AWS Cognito User Pool'"
  }
}

resource "aws_cognito_user_pool" "booking-services-pool" {
  name                     = var.user_pool_name
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "github_actions_environment_secret" "AWS_ACCESS_KEY_ID" {
  environment = "dev"
  repository  = "steffanciprian/testaws"
  secret_name = "AWS_ACCESS_KEY_ID"
}

resource "github_actions_environment_secret" "AWS_SECRET_ACCESS_KEY" {
  environment = "dev"
  repository  = "steffanciprian/testaws"
  secret_name = "AWS_SECRET_ACCESS_KEY"
}