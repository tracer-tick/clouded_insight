resource "aws_s3_bucket_policy" "aws_s3_bucket_policy" {
  bucket = var.s3_bucket
  policy = var.s3_bucket_policy
}