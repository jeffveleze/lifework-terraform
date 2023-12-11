resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "bucket_acl" {

  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
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
