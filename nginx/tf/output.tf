output "smcd_origin_domain_name" {
  value = auth0_custom_domain_verification.smcd_nginx_verification.origin_domain_name
}

output "smcd_cname_api_key" {
  value = nonsensitive(auth0_custom_domain_verification.smcd_nginx_verification.cname_api_key)
}

output "smcd_verification" {
  value = auth0_custom_domain.smcd_nginx.verification
}

output "smcd_verfication_method" {
  value = auth0_custom_domain.smcd_nginx.verification[0].methods
}

output "ec2_public_ip" {
  value = aws_instance.nginx[0].public_ip
}

output "ec2_public_dns" {
  value = aws_instance.nginx[0].public_dns
}
