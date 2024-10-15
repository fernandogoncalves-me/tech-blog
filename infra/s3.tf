resource "aws_s3_bucket" "hosting" {
  bucket = var.hosting_bucket_name
}

resource "aws_s3_bucket_policy" "hosting" {
  bucket = aws_s3_bucket.hosting.id
  policy = templatefile("./files/s3/bucket_policy.json.tpl", {
    statements = jsonencode([
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.hosting.id}/*"
      }
    ])
  })
}

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.hosting.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
