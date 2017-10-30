
resource "aws_instance" "demoec2" {
  instance_type = "${var.instancetype}"
  ami = "${var.ami}"
  key_name = "${var.keyname}"
  vpc_security_group_ids = ["${var.securitygroup}"]
  subnet_id = "${var.subnet}"
  user_data = "${var.userdata}"
  count = "${var.count}"
}
