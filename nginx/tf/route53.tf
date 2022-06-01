resource "aws_route53_zone" "primary" {
  name = var.aws_route53_hosted_zone_name
  tags = {
    project : var.aws_tag_project
  }
}

resource "aws_route53_record" "auth_verification" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${auth0_custom_domain.smcd_nginx.verification[0].methods[0].domain}."
  type    = upper(auth0_custom_domain.smcd_nginx.verification[0].methods[0].name)
  ttl     = 60
  records = ["${auth0_custom_domain.smcd_nginx.verification[0].methods[0].record}."]
}

resource "aws_route53_record" "smcd_cname" {
  zone_id        = aws_route53_zone.primary.zone_id
  name           = "auth"
  type           = "CNAME"
  ttl            = "60"
  set_identifier = "auth"
  records        = ["${aws_instance.nginx[0].public_dns}"]
  weighted_routing_policy {
    weight = 90
  }
}
