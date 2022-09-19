variable "name" {
  type        = string
  description = "The name of the bucket"
}

variable "bucket_lifecycle_enabled" {
  type        = bool
  description = "Should the bucket lifestyle rules be enabled."
  default     = true
}

variable "bucket_noncurrent_version_expiration" {
  type        = number
  description = "How many days should the non current version be kept?"
  default     = 7
}

variable "bucket_access_principal" {
  description = "This object will grant access to listed principals."
  type        = map(list(string))
  default     = {}
  # bucket_access_principal = { "AWS": [ "arn:aws:iam::XXXXXXXXXXXX:role/role-name" ]
}

variable "bucket_access_action" {
  type        = list(string)
  description = "Access actions for listed principals."
  default     = ["s3:ListBucket", "s3:*Object"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "server_side_encryption" {
  type    = bool
  default = true
}
