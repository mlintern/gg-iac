module "mystery_1" {
  source = "./modules/mystery_1"

  name                   = "lab"
  vpc_security_group_ids = ["sg-0f3c2e991b1df4ed1"]
  subnet_id              = "subnet-0d075ecb98cb83e28"
  profile                = aws_iam_instance_profile.ec2_profile.name
}

module "mystery_2" {
  source = "./modules/mystery_2"

  name = "pail"
}

module "mystery_3" {
  source = "./modules/mystery_3"

  name            = "gg-iac"
  master_username = "gg-iac-admin"
  master_password = "not_a_real_pass"
  engine_version  = "14"
  initial_db_name = "gg-iac"
}
