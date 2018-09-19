//vpc output
#subnet output vars

output "subnet_pri_a_id" {
  value = "${aws_subnet.subnet-pri-a.id}"
}

output "subnet_pri_b_id" {
  value = "${aws_subnet.subnet-pri-b.id}"
}

output "subnet_pri_c_id" {
  value = "${aws_subnet.subnet-pri-c.id}"
}

#security group output vars

output "sg_kube_nodes_id" {
  value = "${aws_security_group.kube-nodes.id}"
}

output "sg_kube_masters_id" {
  value = "${aws_security_group.kube-masters.id}"
}
