resource "aws_route53_zone" "owner_zone" {
  name = var.owner_domain
}

locals {
  auth0_custom_domain = "id.${var.owner_domain}"
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.owner_domain
  validation_method         = "DNS"
  //provider                  = aws.virginia
  subject_alternative_names = [
    var.owner_domain,
    "*.${var.owner_domain}"
  ]
}

resource "aws_route53_record" "custom_domain_verification_record" {
  zone_id = aws_route53_zone.owner_zone.id
  name    = "_cf-custom-hostname.${local.auth0_custom_domain}."
  records = ["${auth0_custom_domain.custom_domain.verification[0].methods[0].record}."]
  type    = upper(auth0_custom_domain.custom_domain.verification[0].methods[0].name)
  ttl     = 300
}


resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.owner_zone.id
  name    = local.auth0_custom_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.custom_domain_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.custom_domain_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "cloudfront_logs" {
  bucket_prefix = "cloudfront-logs-fps-"
  tags = {
    Name        = "cloudfront-logs-fps"
  }
}

resource "aws_s3_bucket_acl" "cloudfront_logs_acl" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  acl    = "private"
}

resource "aws_cloudfront_distribution" "custom_domain_distribution" {
  enabled     = true
  price_class = "PriceClass_100"

  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.cloudfront_logs.bucket_regional_domain_name
    prefix          = "fps"
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.auth0_custom_domain
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = aws_lambda_function.fps.qualified_arn
    }

  }

  origin {
    domain_name = auth0_custom_domain_verification.custom_domain_verification.origin_domain_name
    origin_id   = local.auth0_custom_domain
    custom_header {
      name  = "cname-api-key"
      value = auth0_custom_domain_verification.custom_domain_verification.cname_api_key
    }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

  }

  aliases = [
    local.auth0_custom_domain
  ]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.certificate.arn
    ssl_support_method  = "sni-only"
  }

}
