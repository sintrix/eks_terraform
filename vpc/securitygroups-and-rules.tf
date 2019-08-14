# Security Groups and Rules

##################
# Security Groups
##################
# Security Group #1
resource "aws_security_group" "kube-masters" {
  name        = "sg_eks-masters-${var.deployment-env}"
  description = "Kube masters security group"
  vpc_id      = "${aws_vpc.demo-eks-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name              = "sg_kube-masters-${var.deployment-env}"
    KubernetesCluster = "${var.deployment-env}.${var.root-domain-name}"
  }
}

# Security Group #2
resource "aws_security_group" "kube-nodes" {
  name        = "sg_eks-nodes-${var.deployment-env}"
  description = "Kubernetes Nodes security group"
  vpc_id      = "${aws_vpc.demo-eks-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name              = "sg_kube-nodes-${var.deployment-env}"
    KubernetesCluster = "${var.deployment-env}.${var.root-domain-name}"
  }
}


##################
# Rules
##################
# Adding rules after SG instead of with the SG prevents dependency issues in certain situations
# Security Group #1 Rules
resource "aws_security_group_rule" "kube-masters-01" {
  type                     = "ingress"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.kube-nodes.id}"
  security_group_id        = "${aws_security_group.kube-masters.id}"
}

resource "aws_security_group_rule" "kube-masters-02" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = "${aws_security_group.kube-masters.id}"
}

resource "aws_security_group_rule" "kube-masters-03" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube-masters.id}"
}

resource "aws_security_group_rule" "kube-masters-04" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube-masters.id}"
}

# Security Group #2 Rules
resource "aws_security_group_rule" "kube-nodes-01" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube-nodes.id}"
}

resource "aws_security_group_rule" "kube-nodes-02" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "6"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.kube-nodes.id}"
}

resource "aws_security_group_rule" "kube-nodes-03" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kube-nodes.id}"
}

resource "aws_security_group_rule" "kube-nodes-04" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "6"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.kube-nodes.id}"
}

resource "aws_security_group_rule" "kube-nodes-05" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = "${aws_security_group.kube-nodes.id}"
}

resource "aws_security_group_rule" "kube-nodes-07" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.kube-masters.id}"
  security_group_id        = "${aws_security_group.kube-nodes.id}"
}
