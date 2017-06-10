terraform {
  backend "s3" {
    bucket = "2pmbatch" 
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "aws_s3" {
  backend = "s3"
  config {
    bucket = "2pmbatch"
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
  }
}
