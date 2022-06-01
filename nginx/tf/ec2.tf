resource "aws_instance" "nginx" {
  instance_type               = var.aws_ec2_instance_type
  ami                         = lookup(var.aws_ec2_amis, var.aws_region)
  count                       = var.aws_ec2_instance_count
  key_name                    = var.aws_ec2_keypair_name
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh_http.id}"]
  subnet_id                   = element(module.vpc.public_subnets, count.index)
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/files/user-data.sh", {
    CNAME_API_KEY       = auth0_custom_domain_verification.smcd_nginx_verification.cname_api_key,
    AUTH0_EDGE_RECORD   = auth0_custom_domain_verification.smcd_nginx_verification.origin_domain_name,
    AUTH0_CUSTOM_DOMAIN = var.aws_route53_auth_record,
    EMAIL               = var.certbot_email_contact
  })
  tags = {
    "project" = var.aws_tag_project
  }
}


