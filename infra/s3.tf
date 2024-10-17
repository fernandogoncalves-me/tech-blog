resource "aws_s3_bucket" "hosting" {
  bucket = var.hosting_bucket_name
}

resource "aws_s3_bucket_policy" "hosting" {
  bucket = aws_s3_bucket.hosting.id
  policy = templatefile("./files/s3/bucket_policy.json.tpl", {
    bucket_name                 = aws_s3_bucket.hosting.id,
    cloudfront_distribution_arn = aws_cloudfront_distribution.blog.arn
  })
}
