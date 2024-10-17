resource "aws_acm_certificate" "blog" {
  provider = aws.us-east-1

  domain_name       = "fernando.cloudtalents.io"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
