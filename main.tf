provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

# Create an S3 bucket
resource "aws_s3_bucket" "popo24_public_read_images" {
  bucket = "popo24-public-read-images"  # Bucket name

  tags = {
    Name = "popo24-public-read-images"
  }
}

# Configure bucket policy to allow public read access
resource "aws_s3_bucket_policy" "popo24_public_read_images_policy" {
  bucket = aws_s3_bucket.popo24_public_read_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = [
          "${aws_s3_bucket.popo24_public_read_images.arn}/*"
        ]
      }
    ]
  })
}

# Configure S3 bucket ACL to enforce object ownership
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.popo24_public_read_images.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure S3 bucket public access block settings
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.popo24_public_read_images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
