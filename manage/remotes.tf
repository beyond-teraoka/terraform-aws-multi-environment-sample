data "terraform_remote_state" "dev" {
  backend = "local"
  config = {
    path = "../develop/terraform.tfstate"
  }
}

data "terraform_remote_state" "prod" {
  backend = "local"
  config = {
    path = "../production/terraform.tfstate"
  }
}
