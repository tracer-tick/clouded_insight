variable "s3_bucket" {
  type        = string
  description = "Bucket name that the policy will apply to"
}

variable "s3_bucket_policy" {
  type        = string
  description = "The bucket policy to apply"
}