//ec2 output

#keypair
output "kubenodes-public-key" {
  value = "${aws_key_pair.kubenodes-pub.key_name}"
}
