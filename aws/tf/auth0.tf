resource "auth0_tenant" "tenant_config" {
  friendly_name = "First Party Set Demo"
  support_email = "amin.abbaspour@okta.com"
  allowed_logout_urls = []
  flags {
    enable_client_connections = false
  }
}

//noinspection MissingProperty
resource "auth0_custom_domain" "custom_domain" {
  domain = local.auth0_custom_domain
  type = "self_managed_certs"
}

resource "auth0_custom_domain_verification" "custom_domain_verification" {
  custom_domain_id = auth0_custom_domain.custom_domain.id
  timeouts { create = "5m" }
  depends_on = [ aws_route53_record.custom_domain_verification_record ]
}


resource "auth0_client" "client_jwt" {
  name = "JWT.io"
  description = "Client for testing"
  app_type = "spa"
  oidc_conformant = true
  is_first_party = true

  callbacks = [
    "https://jwt.io"
  ]

  jwt_configuration {
    alg = "RS256"
  }
}

resource "auth0_client" "client_member_spa" {
  name = "life-app"
  description = "SPA for member website"
  app_type = "spa"
  oidc_conformant = true
  is_first_party = true

  token_endpoint_auth_method = "none"

  callbacks = [
    "https://www.abbaspour.life",
    "https://abbaspour-life.netlify.app",
    "http://localhost:3000"
  ]

  allowed_logout_urls = [
    "https://www.abbaspour.life",
    "https://abbaspour-life.netlify.app",
    "http://localhost:3000"
  ]

  allowed_origins = [
    "https://www.abbaspour.life"
  ]

  jwt_configuration {
    alg = "RS256"
  }

  grant_types = [
    "implicit", "authorization_code", "refresh_token"
  ]
}

resource "auth0_client" "client_owner_spa" {
  name = "live-app"
  description = "SPA for owner website"
  app_type = "spa"
  oidc_conformant = true
  is_first_party = true

  token_endpoint_auth_method = "none"

  callbacks = [
    "https://www.abbaspour.live",
    "https://abbaspour-live.netlify.app",
    "http://localhost:3001"
  ]

  allowed_logout_urls = [
    "https://www.abbaspour.live",
    "https://abbaspour-live.netlify.app",
    "http://localhost:3001"
  ]

  allowed_origins = [
  ]

  jwt_configuration {
    alg = "RS256"
  }

  grant_types = [
    "implicit", "authorization_code", "refresh_token"
  ]
}

data "auth0_global_client" "global" {
}

resource "auth0_connection" "users" {
  name = "users"
  display_name = "Demo users"
  strategy = "auth0"
  is_domain_connection = true
  options {
    password_policy = "low"
    password_complexity_options {
      min_length = 5
    }
  }


  enabled_clients = [
    var.auth0_tf_client_id,
    auth0_client.client_jwt.client_id,
    auth0_client.client_owner_spa.client_id,
    auth0_client.client_member_spa.client_id
  ]
}

resource "auth0_user" "user_amin" {
  connection_name = auth0_connection.users.name
  email = "amin@okta.com"
  password = "amin@okta.com"
  user_metadata = "{\"lang\":\"en\"}"
  email_verified = true
  lifecycle {
    ignore_changes = [email_verified]
  }
}

output "member_client_id" {
  value = auth0_client.client_member_spa.client_id
}

output "authorize_request" {
  value = "https://${local.auth0_custom_domain}/authorize?client_id=${auth0_client.client_jwt.client_id}&connection=${auth0_connection.users.name}&scope=openid%20profile&nonce=mynonce&response_type=id_token%20token&login_hint=${auth0_user.user_amin.email}"
}
