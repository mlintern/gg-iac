module "mystery_1" {
  source = "./modules/mystery_1"

  name = "lab"
  vpc_security_group_ids = []
  subnet_id = ""
}

module "mystery_2" {
  source = "./modules/mystery_2"

  name = "pail"
}

module "mystery_3" {
  source = "./modules/mystery_3"

  name = "gg-iac"
  master_username = "gg-iac-admin"
  master_password = "not_a_real_pass"
  engine_version = "14"
  initial_db_name = "gg-iac"
}
