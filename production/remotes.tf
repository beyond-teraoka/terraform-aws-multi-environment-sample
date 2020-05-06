data "terraform_remote_state" "mng" {
  backend = "local"
  config = {
    path = "../manage/terraform.tfstate"
  }
}
