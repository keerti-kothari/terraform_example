
output "elb-dns" {
  value = "${aws_elb.demo-elb.dns_name}"
}
