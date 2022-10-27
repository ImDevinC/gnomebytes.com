module "bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.bucket_name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.bucket.s3_bucket_arn}/*"]
    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = module.bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
