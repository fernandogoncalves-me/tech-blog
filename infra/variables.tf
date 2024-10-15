variable "hosting_bucket_name" {
  type        = string
  description = "Name of the S3 Bucket used to host the blog"
  sensitive   = true
}
