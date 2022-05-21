resource "auth0_tenant" "tenant_config" {
  friendly_name = "First Party Set Demo"
  support_email = "amin.abbaspour@auth0.com"
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
  timeouts { create = "15m" }
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

data "auth0_global_client" "global" {
}

resource "auth0_connection" "users" {
  name = "Users"
  display_name = "Demo users"
  strategy = "auth0"
  is_domain_connection = true
  options {
    password_policy = "low"
    password_complexity_options {
      min_length = 5
    }
  }


  enabled_clients = [ auth0_client.client_jwt.client_id, var.auth0_tf_client_id ]
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
