resource "cloudflare_zone" "owner_zone" {
  zone = var.owner_domain
}

locals {
  auth0_custom_domain = "id.${var.owner_domain}"
}

resource "cloudflare_page_rule" "custom_domain_page_rule" {
  zone_id = cloudflare_zone.owner_zone.id
  target = "${local.auth0_custom_domain}/*"
  priority = 1

  actions {
    always_use_https = true
  }
}

resource "auth0_custom_domain" "custom_domain" {
  domain = local.auth0_custom_domain
  type = "self_managed_certs"
}

resource "auth0_custom_domain_verification" "custom_domain_verification" {
  custom_domain_id = auth0_custom_domain.custom_domain.id
  timeouts { create = "15m" }
  depends_on = [ cloudflare_record.custom_domain_verification_record ]
}

resource "cloudflare_record" "custom_domain_verification_record" {
  zone_id = cloudflare_zone.owner_zone.id
  name = "_cf-custom-hostname.${local.auth0_custom_domain}."
  value = "${auth0_custom_domain.custom_domain.verification[0].methods[0].record}."
  type    = upper(auth0_custom_domain.custom_domain.verification[0].methods[0].name)
  ttl     = 300
}


resource "cloudflare_worker_script" "cname_worker_script" {
  name = "first-party-set-owner-cname-worker"


  content = file("worker.js")

  secret_text_binding {
    name = "MY_EXAMPLE_PLAIN_TEXT"
    text = "foobar"
  }

  plain_text_binding {
    name = "CNAME_API_KEY"
    text = auth0_custom_domain_verification.custom_domain_verification.cname_api_key
  }

}

resource "cloudflare_worker_route" "cname_worker_script_route" {
  zone_id = cloudflare_zone.owner_zone.id
  pattern = "${local.auth0_custom_domain}/*"
  script_name = cloudflare_worker_script.cname_worker_script.name
}

resource "cloudflare_ruleset" "custom_domain_rewrite_host" {
  zone_id     =  cloudflare_zone.owner_zone.id
  name        = "Transform Rule performing HTTP request header modifications"
  description = "rewrite host to edge location"
  kind        = "zone"
  phase       = "http_request_late_transform"
  rules {
    action = "rewrite"
    action_parameters {
      headers {
        name      = "Host"
        operation = "set"
        value     = auth0_custom_domain_verification.custom_domain_verification.origin_domain_name
      }
    }
    expression = "true"
    description = "Example HTTP Request Header Modification Rule"
    enabled = true
  }
}

