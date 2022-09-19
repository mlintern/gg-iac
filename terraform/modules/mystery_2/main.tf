resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id = "expiration"

    expiration {
      days = var.bucket_noncurrent_version_expiration
    }

    filter {}

    status = var.bucket_lifecycle_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.server_side_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true

  # Let the bucket creation happen first. This can fail if the bucket is in flight.
  depends_on = [
    aws_s3_bucket.this,
  ]
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "${var.bucket_name}-access-policy",
    "Statement" : [
      {
        "Sid" : "S3BucketAllow",
        "Effect" : "Allow",
        "Principal" : "${var.bucket_access_principal}",
        "Action" : "${var.bucket_access_action}",
        "Resource" : [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*"
        ]
      },
      {
        "Sid" : "DenyIfNotTls",
        "Effect" : "Deny",
        "Action" : ["s3:*"],
        "Principal" : "*",
        "Resource" : [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.this,
  ]
}

data "aws_caller_identity" "current" {}
