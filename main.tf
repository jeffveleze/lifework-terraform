resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_acccess_block" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_acccess_block,
  ]

  bucket = aws_s3_bucket.app_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

output "website_domain" {
  value = aws_s3_bucket_website_configuration.website_config.website_domain
}

output "website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}
