variable "region" {
  default = "ap-southeast-2"
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

