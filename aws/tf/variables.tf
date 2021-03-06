variable "region" {
  //default = "ap-southeast-2"
  default = "us-east-1" // it's much easier to run everything in us-east-1 when doing lambda@edge
}

variable "owner_domain" {
  type = string
  description = "owner domain of fist-party-set"
}

variable "auth0_subdomain" {
  type = string
  description = "subdomain for auth0"
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

variable "lambda_version" {
  type = string
  description = "lambda version"
}
