resource "aws_instance" "this" {
  ami                     = data.aws_ami.ubuntu_bionic_arm64.id
  instance_type           = "t4g.small"
  disable_api_termination = false
  ebs_optimized           = true
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id
  iam_instance_profile    = var.profile
  monitoring              = true

  root_block_device {
    volume_size = 32
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Environment = "test"
    Name        = var.name
    Terraform   = "true"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
