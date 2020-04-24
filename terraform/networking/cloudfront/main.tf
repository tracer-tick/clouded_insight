resource "aws_cloudfront_distribution" "aws_cloudfront_distribution" {


  origin {
    domain_name = var.image_bucket_name
    origin_id   = var.origin_id

  }

  default_cache_behavior {
    allowed_methods         = ["GET", "HEAD"]
    cached_methods          = ["GET", "HEAD"]
    target_origin_id        = var.origin_id
    viewer_protocol_policy  = "allow-all"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["US"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}