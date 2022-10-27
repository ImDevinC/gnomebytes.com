resource "aws_acm_certificate" "main" {
  domain_name       = "gnomebytes.com"
  validation_method = "DNS"
  provider          = aws.useast1
  subject_alternative_names = [
    "www.gnomebytes.com"
  ]
  lifecycle {
    create_before_destroy = true
  }
}
