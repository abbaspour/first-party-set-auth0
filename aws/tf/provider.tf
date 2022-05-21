terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.15"
    }
    virginia = {
      source = "hashicorp/aws"
      version = "~> 4.15"
    }
    auth0 = {
      source = "auth0/auth0"
      version = "~> 0.30"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "virginia" {
  region = "us-east-1"
}

provider "auth0" {
  domain = var.auth0_domain
  client_id = var.auth0_tf_client_id
  client_secret = var.auth0_tf_client_secret
  debug = "true"
}

