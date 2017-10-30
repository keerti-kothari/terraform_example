
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "demovpc" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_internet_gateway" "demoigw" {
  vpc_id = "${aws_vpc.demovpc.id}"
}

resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.demovpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.demoigw.id}"
}

resource "aws_subnet" "demosub" {
  vpc_id = "${aws_vpc.demovpc.id}"
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "elbsg" {
  name = "elb-sg"
  vpc_id = "${aws_vpc.demovpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2sg" {
  name = "ec2-sg"
  vpc_id = "${aws_vpc.demovpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "demo-elb"
  subnets = ["${aws_subnet.demosub.id}"]
  security_groups = ["${aws_security_group.elbsg.id}"]
  instances = ["${module.instance1.instance_id}", "${module.instance2.instance_id}"]
  connection_draining = true
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

module "instance1" {
  source = "./modules/instance"
  instancetype = "t2.micro"
  ami = "${lookup(var.amis, var.region)}"
  keyname = "${aws_key_pair.auth.id}"
  securitygroup = "${aws_security_group.ec2sg.id}"
  subnet = "${aws_subnet.demosub.id}"
  userdata = "${file("userdata.sh")}"
  count = "1"
}

module "instance2" {
  source = "./modules/instance"
  instancetype = "t2.micro"
  ami = "${lookup(var.amis, var.region)}"
  keyname = "${aws_key_pair.auth.id}"
  securitygroup = "${aws_security_group.ec2sg.id}"
  subnet = "${aws_subnet.demosub.id}"
  userdata = "${file("userdata1.sh")}"
  count = "2"
}
