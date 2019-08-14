# Subnet output variables
output "subnet-public-a-id" {
  value = "${aws_subnet.subnet-public-a.id}"
}

output "subnet-public-b-id" {
  value = "${aws_subnet.subnet-public-b.id}"
}

output "subnet-public-c-id" {
  value = "${aws_subnet.subnet-public-c.id}"
}

# Security group output variables
output "sg-kube-masters-id" {
  value = "${aws_security_group.kube-masters.id}"
}

output "sg-kube-nodes-id" {
  value = "${aws_security_group.kube-nodes.id}"
}
