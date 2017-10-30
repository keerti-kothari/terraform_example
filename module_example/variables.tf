variable "access_key" {

}

variable "secret_key" {

}

variable "region" {
  default = "us-east-1"
}

variable "public_key_path" {
  description = "Path to my Public Key"
  default = "/root/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to my private Key"
  default = "/root/.ssh/id_rsa"
}

variable "key_name" {
  default = "demokey"
}

variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-8c1be5f6"
    us-east-2 = "ami-c5062ba0"
    us-west-1 = "ami-02eada62"
    us-west-2 = "ami-e689729e"
  }
}
