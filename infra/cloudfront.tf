locals {
  s3_origin_id = "s3Hosting"
}

resource "aws_cloudfront_distribution" "blog" {
  aliases             = ["fernando.cloudtalents.io"]
  enabled             = true
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  origin {
    domain_name              = aws_s3_bucket.hosting.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.blog.id
    origin_id                = local.s3_origin_id
  }

  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/404.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.append_index.arn
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.blog.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_function" "append_index" {
  name    = "append-index"
  runtime = "cloudfront-js-2.0"
  comment = "Appends index.html to the end of every path"
  publish = true
  code    = file("${path.module}/files/cloudfront/append_index.js")
}

resource "aws_cloudfront_origin_access_control" "blog" {
  name                              = "blog"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
