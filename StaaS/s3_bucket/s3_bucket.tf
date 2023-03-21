resource "aws_s3_bucket" "bucket" {
  provider = aws
  bucket   = var.s3_bucket_name
}

output "id" {
  value = aws_s3_bucket.bucket.id
}