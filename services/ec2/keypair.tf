# Keypair for worker nodes
resource "aws_key_pair" "kubenodes-pub" {
  key_name   = "kubenodes-${var.deployment-env}.pub"
  public_key = "${file("./public-keys/kubenodes-${var.deployment-env}.pub")}"
}
