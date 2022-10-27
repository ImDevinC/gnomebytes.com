module "zones" {
  source = "terraform-aws-modules/route53/aws//modules/zones"
  zones = {
    (local.domain_name) = {}
  }
}

locals {
  dvo_records = [
    for dvo in aws_acm_certificate.main.domain_validation_options : {
      name               = dvo.resource_record_name
      records            = [dvo.resource_record_value]
      type               = dvo.resource_record_type
      full_name_override = true
      ttl                = 300
    }
  ]
}

module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = local.domain_name

  records = concat(local.dvo_records, [
    {
      name = ""
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
    {
      name    = "www"
      type    = "CNAME"
      records = [local.domain_name]
      ttl     = 3600
    }
  ])
}
