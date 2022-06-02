resource "auth0_custom_domain" "smcd" {
  domain = "${var.auth0_smcd_prefix}.${var.fpset_owner_domain}"
  type   = "self_managed_certs"
}

resource "auth0_custom_domain_verification" "smcd_verification" {
  custom_domain_id = auth0_custom_domain.smcd.id
  timeouts { create = "120m" }
  depends_on = [cloudflare_record.auth0_smcd_verification]
}

