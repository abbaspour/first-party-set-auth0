# aws provider config
variable "aws_region" {
  description = "AWS Region"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  sensitive   = true
}

# aws tag for all resources
variable "aws_tag_project" {
  description = "AWS Tag on All Resources"
}

# route53
variable "aws_route53_hosted_zone_name" {
  description = "Route53 Hosted Zone Name"
}

variable "aws_route53_auth_record" {
  description = "Route53 auth record for Auth0 SMCD"
}

# aws vpc
variable "aws_vpc_nginx" {
  description = "AWS VPC for Nginx"
}

# aws ec2 config
variable "aws_ec2_amis" {
  default = {
    # Amazon Linux
    us-east-1 = "ami-0022f774911c1d690"
  }
}

variable "aws_ec2_instance_type" {
  description = "Type of AWS EC2 instance."
  default     = "t2.micro"
}

variable "aws_ec2_keypair_name" {
  description = "AWS keypair name"
}

variable "aws_ec2_instance_count" {
  default = 1
}

# auth0 provider config
variable "auth0_domain" {
  description = "Auth0 Domain"
}

variable "auth0_client_id" {
  description = "Auth0 Client ID"
}

variable "auth0_client_secret" {
  description = "Auth0 Client Secret"
}

# certbot
variable "certbot_email_contact" {
  description = "Email contact for requesting TLS cert from Let's Encrypt"
}

