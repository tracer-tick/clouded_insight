variable "image_bucket_name" {
  type        = string
  description = "The name of the image bucket"
}
variable "origin_id" {
  type        = string
  description = "A unique ID for the origin"
}
variable "region" {
  type        = string
  description = "The region where the bucket will reside"
}