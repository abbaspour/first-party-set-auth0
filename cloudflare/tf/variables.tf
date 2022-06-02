# cloudflare config
variable "cloudflare_email" {
  type        = string
  description = "cloudflare email"
}

variable "cloudflare_account_id" {
  type        = string
  description = "cloudflare account_id"
}

variable "cloudflare_api_key" {
  type        = string
  description = "cloudflare api key"
  sensitive   = true
}

# domains config
variable "fpset_owner_domain" {
  description = "First Party Set Owner Domain"
}

variable "fpset_member_domains_list" {
  description = "First Party Set Members Domains List"
  type        = list(string)
}

variable "fpset_owner_app_origin" {
  description = "App hosting URL (Netlify, Vercel etc.)"
}

variable "fpset_member_app_origins_list" {
  type        = list(string)
  description = "App hosting URLs (Netlify, Vercel etc.)"
}

# auth0 config
variable "auth0_domain" {
  description = "Auth0 Domain"
}

variable "auth0_client_id" {
  description = "Auth0 Client ID"
}

variable "auth0_client_secret" {
  description = "Auth0 Client Secret"
}

variable "auth0_smcd_prefix" {
  description = "Subdomain (prefix only, not FQDN) for Auth0 Custom Domain"
  default     = "auth"
}
