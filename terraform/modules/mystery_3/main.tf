resource "aws_rds_cluster" "this" {
  deletion_protection                 = var.deletion_protection
  availability_zones                  = var.availability_zones
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  backup_retention_period             = var.backup_retention_period
  cluster_identifier                  = var.name
  database_name                       = var.initial_db_name
  db_subnet_group_name                = var.db_subnet_group == "" ? aws_db_subnet_group.this[0].name : var.db_subnet_group
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  master_password                     = var.master_password
  master_username                     = var.master_username
  iam_database_authentication_enabled = length(regexall("aurora", var.engine)) > 0
  allocated_storage                   = var.allocated_storage
  db_cluster_instance_class           = var.db_cluster_instance_class
  preferred_backup_window             = "${local.backup_start}-${local.backup_end}"
  skip_final_snapshot                 = true
  snapshot_identifier                 = var.snapshot_to_restore
  storage_encrypted                   = true
  storage_type                        = var.storage_type
  iops                                = var.iops
  vpc_security_group_ids              = [var.security_group == "" ? aws_security_group.this[0].id : var.security_group]
  port                                = var.db_port != 0 ? var.db_port : lookup(local.db_ports, var.engine)
  tags                                = local.cluster_tags

  lifecycle {
    ignore_changes = [
      database_name
    ]
  }
}

resource "aws_rds_cluster_instance" "this" {
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  cluster_identifier         = aws_rds_cluster.this.id
  count                      = var.instance_count
  engine                     = aws_rds_cluster.this.engine
  engine_version             = aws_rds_cluster.this.engine_version
  identifier                 = "${var.name}-${count.index}"
  instance_class             = var.instance_class
  tags                       = merge(local.instance_tags, { Name = "${var.name}-Instance-${count.index}" })
}
