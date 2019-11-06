module "app_server" {
  source = "../terraform_1/main.tf"
}

module "bastion_server" {
  source = "../terraform_1/bastion_host.tf"
}
