resource "aws_acm_certificate" "main" {
  domain_name       = "gnomebytes.com"
  validation_method = "DNS"
  provider          = aws.useast1
  lifecycle {
    create_before_destroy = true
  }
}
