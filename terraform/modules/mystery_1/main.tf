resource "aws_instance" "us_utility" {
  ami                     = data.aws_ami.ubuntu_bionic_arm64.id
  instance_type           = "t3a.small"
  disable_api_termination = true
  ebs_optimized           = true
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id

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
}
