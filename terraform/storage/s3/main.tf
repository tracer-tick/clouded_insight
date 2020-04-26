resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = var.bucket_name
  region = var.region
  force_destroy = true
}