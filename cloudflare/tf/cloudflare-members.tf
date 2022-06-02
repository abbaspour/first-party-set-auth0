# add a zone for each member domain
resource "cloudflare_zone" "fpset_members" {
  count = length(var.fpset_member_domains_list)
  zone  = var.fpset_member_domains_list[count.index]
}

# add CNAME record for app member origin
resource "cloudflare_record" "fpset_member_app" {
  count   = length(var.fpset_member_app_origins_list)
  zone_id = cloudflare_zone.fpset_members[count.index].id
  type    = "CNAME"
  name    = "@"
  value   = var.fpset_member_app_origins_list[count.index]
  proxied = true
  ttl     = 1
}

# add CNAME record for app member origin
resource "cloudflare_record" "fpset_member_app_www" {
  count   = length(var.fpset_member_app_origins_list)
  zone_id = cloudflare_zone.fpset_members[count.index].id
  type    = "CNAME"
  name    = "www"
  value   = var.fpset_member_app_origins_list[count.index]
}

# set worker to return fpset metadata
resource "cloudflare_worker_route" "fpset_member_route" {
  count       = length(var.fpset_member_domains_list)
  zone_id     = cloudflare_zone.fpset_members[count.index].id
  pattern     = "${var.fpset_member_domains_list[count.index]}/.well-known/first-party-set"
  script_name = cloudflare_worker_script.fpset_member_worker.name
}

# configure worker to proxy auth0 routes
resource "cloudflare_worker_script" "fpset_member_worker" {
  name    = "fpset_member_worker"
  content = file("../src/fpset-member-worker.js")

  plain_text_binding {
    name = "FPSET_OWNER_DOMAIN"
    text = jsonencode(var.fpset_owner_domain)
  }
}

