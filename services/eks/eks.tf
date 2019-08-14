# EKS
# https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#eks-master-cluster
# https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

# Data AMI
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.demo-eks.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"]
}

# Data AWS Default roles
data "aws_iam_role" "AWSServiceRoleForAutoScaling" {
  name = "AWSServiceRoleForAutoScaling"
}

# If the above role does not exist. create it via gui or uncomment below

# resource "aws_iam_service_linked_role" "as" {
#   aws_service_name = "autoscaling.amazonaws.com"
# }

##############
# Master Role
##############
# Create role and attach policy for master node
resource "aws_iam_role" "kube-master" {
  name        = "demo-eks-master-node"
  description = "Allows EKS to manage clusters on your behalf."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "kube-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.kube-master.name}"
}

resource "aws_iam_role_policy_attachment" "kube-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.kube-master.name}"
}

##############
# Worker Role
##############
# Worker node policy
resource "aws_iam_role" "kube-node" {
  name = "demo-eks-kube-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "kube-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.kube-node.name}"
}

resource "aws_iam_role_policy_attachment" "kube-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.kube-node.name}"
}

resource "aws_iam_role_policy_attachment" "kube-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.kube-node.name}"
}

##############
# Cluster Info
##############
# Create instance profile
resource "aws_iam_instance_profile" "kube-node" {
  name = "demo-eks-kube-node"
  role = "${aws_iam_role.kube-node.name}"
}

# Create EKS cluster
# https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
resource "aws_eks_cluster" "demo-eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.kube-master.arn}"

  vpc_config {
    subnet_ids         = ["${var.subnet-public-a-id}", "${var.subnet-public-b-id}", "${var.subnet-public-c-id}"]
    security_group_ids = ["${var.sg-kube-masters-id}"]
  }
}


##############
# Auto-scaling
##############
# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# Scaling documentation: https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html
# Example: https://geekdudes.wordpress.com/2018/01/10/amazon-autosclaing-using-terraform/
locals {
  kube-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo-eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo-eks.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

# Launch Config
resource "aws_launch_configuration" "kube-nodes" {
  associate_public_ip_address = true
  key_name                    = "${var.kubenodes-public-key}"
  iam_instance_profile        = "${aws_iam_instance_profile.kube-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m5.large"
  name_prefix                 = "demo-eks-node"
  security_groups             = ["${var.sg-kube-nodes-id}"]
  user_data_base64            = "${base64encode(local.kube-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling Group
# https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
# Verify the policy below.
resource "aws_autoscaling_group" "kube-nodes" {
  launch_configuration    = "${aws_launch_configuration.kube-nodes.id}"
  desired_capacity        = "3"
  max_size                = 10
  min_size                = 3
  name                    = "demo-eks-nodes"
  vpc_zone_identifier     = ["${var.subnet-public-a-id}", "${var.subnet-public-b-id}", "${var.subnet-public-c-id}"]
  service_linked_role_arn = "${data.aws_iam_role.AWSServiceRoleForAutoScaling.arn}"

  tag {
    key                 = "Name"
    value               = "${var.cluster-name}-${var.deployment-env}-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
