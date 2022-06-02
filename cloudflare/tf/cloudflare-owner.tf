# add a zone for the owner domain
resource "cloudflare_zone" "fpset_owner" {
  zone = var.fpset_owner_domain
}

# add CNAME record for app owner origin
resource "cloudflare_record" "fpset_owner_app" {
  zone_id = cloudflare_zone.fpset_owner.id
  type    = "CNAME"
  name    = "@"
  value   = var.fpset_owner_app_origin
  proxied = true
  ttl     = 1
}

# add CNAME record for app owner origin
resource "cloudflare_record" "fpset_owner_app_www" {
  zone_id = cloudflare_zone.fpset_owner.id
  type    = "CNAME"
  name    = "www"
  value   = var.fpset_owner_app_origin
  ttl     = 60
}

# add an auth0 verification record to the owner zone
resource "cloudflare_record" "auth0_smcd_verification" {
  zone_id = cloudflare_zone.fpset_owner.id
  type    = upper(auth0_custom_domain.smcd.verification[0].methods[0].name)
  name    = auth0_custom_domain.smcd.verification[0].methods[0].domain
  value   = auth0_custom_domain.smcd.verification[0].methods[0].record
  ttl     = 60
}

# add an auth0 CNAME record to the owner zone
resource "cloudflare_record" "auth0_smcd_cname" {
  zone_id = cloudflare_zone.fpset_owner.id
  name    = var.auth0_smcd_prefix
  type    = "CNAME"
  value   = auth0_custom_domain_verification.smcd_verification.origin_domain_name
  proxied = true
  ttl     = 1
}

# set worker to proxy auth0 routes
resource "cloudflare_worker_route" "auth0_route" {
  zone_id     = cloudflare_zone.fpset_owner.id
  pattern     = "${var.auth0_smcd_prefix}.${var.fpset_owner_domain}/*"
  script_name = cloudflare_worker_script.auth0_worker.name
}

# configure worker to proxy auth0 routes
resource "cloudflare_worker_script" "auth0_worker" {
  name    = "fpset_auth0_smcd_worker"
  content = file("../src/auth0-smcd-worker.js")

  plain_text_binding {
    name = "AUTH0_EDGE_RECORD"
    text = auth0_custom_domain_verification.smcd_verification.origin_domain_name
  }

  secret_text_binding {
    name = "AUTH0_CNAME_API_KEY"
    text = auth0_custom_domain_verification.smcd_verification.cname_api_key
  }
}

# set worker to return fpset metadata
resource "cloudflare_worker_route" "fpset_owner_route" {
  zone_id     = cloudflare_zone.fpset_owner.id
  pattern     = "${var.fpset_owner_domain}/.well-known/first-party-set"
  script_name = cloudflare_worker_script.fpset_owner_worker.name
}

# configure worker to proxy auth0 routes
resource "cloudflare_worker_script" "fpset_owner_worker" {
  name    = "fpset_owner_worker"
  content = file("../src/fpset-owner-worker.js")

  plain_text_binding {
    name = "FPSET_OWNER_DOMAIN"
    text = jsonencode(var.fpset_owner_domain)
  }

  plain_text_binding {
    name = "FPSET_MEMBER_DOMAINS_JSON_ARRAY"
    text = jsonencode(var.fpset_member_domains_list)
  }
}
