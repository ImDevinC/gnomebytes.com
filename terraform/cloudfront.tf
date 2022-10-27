module "cloudfront" {
  source = "terraform-aws-modules/cloudfront/aws"
  aliases = [
    local.domain_name,
    "www.${local.domain_name}"
  ]
  price_class                   = "PriceClass_100"
  create_origin_access_identity = true
  default_root_object           = "index.html"
  origin_access_identities = {
    site_bucket = "site CF to site s3"
  }
  origin = {
    site_bucket = {
      domain_name = module.bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "site_bucket"
      }
    }
  }
  default_cache_behavior = {
    target_origin_id       = "site_bucket"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = false
  }
  viewer_certificate = {
    acm_certificate_arn = aws_acm_certificate.main.arn
    ssl_support_method  = "sni-only"
  }
}
