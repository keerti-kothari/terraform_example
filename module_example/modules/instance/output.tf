output "instance_id" {
  value = ["${aws_instance.demoec2.*.id}"]
}
