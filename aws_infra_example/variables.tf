variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-c58c1dd3"
    us-east-2 = "ami-4191b524"
    us-west-1 = "ami-7a85a01a"
    us-west-2 = "ami-4836a428"
  }
}

variable "public_key_path" {
  description = "Path to my public key"
  default = "/root/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to my private key"
  default = "/root/.ssh/id_rsa"
}

variable "key_name" {
  description = "Name of my AWS key pair"
  default = "demo-key"
}
