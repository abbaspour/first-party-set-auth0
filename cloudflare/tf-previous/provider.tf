terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    auth0 = {
      source = "auth0/auth0"
      version = "~> 0.30"
    }

  }
}

provider "cloudflare" {
  email   = var.cf_email
  api_key = var.cf_api_key
  account_id = var.cf_account_id
}


provider "auth0" {
  domain = var.auth0_domain
  client_id = var.auth0_tf_client_id
  client_secret = var.auth0_tf_client_secret

}
