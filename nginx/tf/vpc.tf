module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = var.aws_vpc_nginx.name
  cidr                 = var.aws_vpc_nginx.cidr
  azs                  = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets      = var.aws_vpc_nginx.private_subnets
  public_subnets       = var.aws_vpc_nginx.public_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
}
