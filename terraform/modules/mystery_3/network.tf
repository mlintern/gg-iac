resource "aws_security_group" "this" {
  count       = var.security_group == "" ? 1 : 0
  description = "Controls network access to RDS instance ${var.name}."
  name        = "${var.name} - RDS Security Group"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Allow DB Connections"
    from_port       = var.db_port != 0 ? var.db_port : lookup(local.db_ports, var.engine)
    to_port         = var.db_port != 0 ? var.db_port : lookup(local.db_ports, var.engine)
    protocol        = "tcp"
    cidr_blocks     = var.allow_cidrs
    security_groups = var.allow_security_groups
  }
  tags = local.security_group_tags
}

resource "aws_db_subnet_group" "this" {
  count      = var.db_subnet_group == "" ? 1 : 0
  name       = lower("${var.name}_SubnetGroup")
  subnet_ids = var.subnet_ids
  tags       = local.subnet_group_tags
}
