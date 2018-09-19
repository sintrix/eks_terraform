//PUBLIC KEY PAIRS

resource "aws_key_pair" "kubenodes-pub" {
  key_name   = "kubenodes-${var.deployment_env}.pub"
  public_key = "${file("./public_keys/kubenodes-${var.deployment_env}.pub")}"
}
