##
# Put the latest Ubuntu Bionic AMI ARM Acrhitecture into a data var
##
data "aws_ami" "ubuntu_bionic_arm64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
