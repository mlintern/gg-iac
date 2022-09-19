variable "name" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "allow_cidrs" {
  type        = list(string)
  description = "CIDRs from which to allow incoming connections. This can be used in conjunction with allow_security_groups."
  default     = []
}

variable "allow_security_groups" {
  type        = list(string)
  description = "Security group IDs from which to allow incoming connections. This can be used in conjunction with allow_cidrs."
  default     = []
}

variable "availability_zones" {
  type        = list(string)
  description = "The AZs where the Aurora cluster is located."
  default     = null
}

variable "db_subnet_group" {
  type        = string
  description = "Do you have a pre-existing db_subnet_group that you wish to use? Leave blank (also deafult) to create a new one in this module. If creating a new one, you will need to supply values for subnet_ids"
  default     = ""
}

variable "engine" {
  type        = string
  description = "The database engine. Valid Values: aurora, aurora-mysql, aurora-postgresql, mysql, postgres. (Note that mysql and postgres are Multi-AZ RDS clusters)."
  default     = "aurora-postgresql"
}

variable "engine_mode" {
  type        = string
  description = "The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned."
  default     = "provisioned"
}

variable "engine_version" {
  type        = string
  description = <<EOF
The database engine version. Updating this argument results in an outage. 
See the https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.html and https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.Updates.html
documentation for your configured engine to determine this value. 

For example with Aurora MySQL 2, a potential value for this argument is 5.7.mysql_aurora.2.03.2. 
The value can contain a partial version where supported by the API. 

The actual engine version used is returned in the attribute engine_version_actual
EOF
}

variable "db_port" {
  type    = number
  default = 0
}

variable "initial_db_name" {
  type        = string
  description = "The name of the first db to included in the RDS instance."
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "master_username" {
  type = string
}

variable "security_group" {
  type        = string
  description = "Pass in a pre-existing security group; leave blank (also default) to create a new SG automatically. You will likely want to include allow_cidrs and/or allow_security_groups if creating a new SG with this module."
  default     = ""
}

variable "snapshot_to_restore" {
  type        = string
  description = "Use this if you are creating a new cluster from an RDS snapshot."
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "The IDs for the subnets in which the instance will be deployed. This should almost always be a list of private subnets."
  default     = []
}

variable "allocated_storage" {
  type    = number
  default = null
}

variable "storage_type" {
  type    = string
  default = null
}

variable "iops" {
  type    = number
  default = null
}

variable "db_cluster_instance_class" {
  type    = string
  default = null
}

variable "vpc_id" {
  type        = string
  description = "ID of the target VPC. This is necessary when security_group is empty."
  default     = ""
}

variable "backup_window_start" {
  type        = string
  description = "Backup window start time in 24hr UTC format."
  default     = "24:00"
}

variable "backup_window_end" {
  type        = string
  description = "Backup window end time in 24hr UTC format. By default this will backup_window_start + backup_window_duration."
  default     = ""
}

variable "backup_window_duration" {
  type        = number
  description = "Total time allowed for the backup window. Defaults to 2 hours. Overidden by backup_window_end."
  default     = 2
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "allow_major_version_upgrade" {
  type    = bool
  default = false
}

variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}

####################
# Shared Variables #
####################

variable "tags" {
  type    = map(any)
  default = {}
}

############
# Tag Vars #
############

variable "cluster_tags" {
  type    = map(any)
  default = {}
}

variable "instance_tags" {
  type    = map(any)
  default = {}
}

variable "subnet_group_tags" {
  type    = map(any)
  default = {}
}

variable "security_group_tags" {
  type    = map(any)
  default = {}
}

locals {
  backup_start            = var.backup_window_start == "24:00" ? "00:00" : var.backup_window_start
  backup_end_hour_invalid = element(split(":", var.backup_window_start), 0) + var.backup_window_duration
  backup_end_minute       = element(split(":", var.backup_window_start), 1)
  backup_end_hour         = var.backup_window_end != "" ? var.backup_window_end : local.backup_end_hour_invalid >= 24 ? local.backup_end_hour_invalid - 24 : local.backup_end_hour_invalid
  backup_end              = length(local.backup_end_hour) == 1 ? "0${local.backup_end_hour}:${local.backup_end_minute}" : "${local.backup_end_hour}:${local.backup_end_minute}"

  cluster_tags        = merge(var.cluster_tags, var.tags, { Name = "${var.name}-RDS-Cluster" })
  instance_tags       = merge(var.instance_tags, var.tags)
  subnet_group_tags   = merge(var.subnet_group_tags, var.tags, { Name = "${var.name}-RDS-SubnetGroup" })
  security_group_tags = merge(var.security_group_tags, var.tags, { Name = "${var.name}-RDS-SecurityGroup" })
}