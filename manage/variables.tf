####################
# Provider
####################
variable "access_key" {
  description = "AWS Access Key"
}

variable "secret_key" {
  description = "AWS Secret Key"
}

variable "role_arn" {
  description = "AWS Role Arn"
}

variable "region" {
  default = "ap-northeast-1"
}
