variable "name" {
  type        = string
  description = "The name of the instance"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "list of security groups for instance"
}

variable "subnet_id" {
  type        = string
  description = "subnet id instace will be created in"
}

variable "profile" {
  type        = string
  description = "value"
}
