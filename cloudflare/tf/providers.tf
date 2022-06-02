terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~>3.16.0"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "0.30.2"
    }
  }
}

# cloudflare provider config
provider "cloudflare" {
  email      = var.cloudflare_email
  account_id = var.cloudflare_account_id
  api_key    = var.cloudflare_api_key
}

# auth0 provider config
provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}
