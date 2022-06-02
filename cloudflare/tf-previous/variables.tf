variable "cf_email" {
  type = string
  description = "Cloudflare account email"
}

variable "cf_api_key" {
  type = string
  description = "Cloudflare API key"
  sensitive = true
}

variable "cf_account_id" {
  type = string
  description = "Cloudflare account ID"
}

variable "owner_domain" {
  type = string
  description = "owner domain of fist-party-set"
}

variable "member_domains" {
  type = set(string)
  description = "members domains of fist-party-set"
}

variable "auth0_domain" {
  type = string
  description = "auth0 domain"
}

variable "auth0_tf_client_id" {
  type = string
  description = "Auth0 TF provider client_id"
}

variable "auth0_tf_client_secret" {
  type = string
  description = "Auth0 TF provider client_secret"
  sensitive = true
}


