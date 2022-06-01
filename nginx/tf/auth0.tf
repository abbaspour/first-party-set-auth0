resource "auth0_custom_domain" "smcd_nginx" {
  domain = var.aws_route53_auth_record
  type   = "self_managed_certs"
}

resource "auth0_custom_domain_verification" "smcd_nginx_verification" {
  custom_domain_id = auth0_custom_domain.smcd_nginx.id
  timeouts { create = "120m" }
  depends_on = [aws_route53_record.auth_verification]
}

