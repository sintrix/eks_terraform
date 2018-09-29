//eks
#https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#eks-master-cluster
#https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

#data ami
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon Account ID
}

#data aws default roles
data "aws_iam_role" "AWSServiceRoleForAutoScaling" {
  name = "AWSServiceRoleForAutoScaling"
}

#if the above role does not exist either create it via gui or uncomment below
/*
resource "aws_iam_service_linked_role" "as" {
  aws_service_name = "autoscaling.amazonaws.com"
}
*/

//role creation and attach policy
#create master node policy
resource "aws_iam_role" "kube-master" {
  name        = "terraform-eks-master-node"
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

#create worker node policy
resource "aws_iam_role" "kube-node" {
  name = "terraform-eks-kube-node"

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

#create instance profile
resource "aws_iam_instance_profile" "kube-node" {
  name = "terraform-eks-kube-node"
  role = "${aws_iam_role.kube-node.name}"
}

//resource creation
#Note: Used private subnets for this lab, you may want to use public subnets for teh masters.
#See: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html

#create eks cluster (k8s master nodes)
resource "aws_eks_cluster" "test-eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.kube-master.arn}"

  vpc_config {
    subnet_ids         = ["${var.subnet_pri_a_id}", "${var.subnet_pri_b_id}", "${var.subnet_pri_c_id}"]
    security_group_ids = ["${var.sg_kube_masters_id}"]
  }
}

//Create AutoScaling Launch Configuration
#create autoscaling launch group

//AWSServiceRoleForAutoScaling

//note: need autoscale policy to scale up/down (policy currently not implemented)
//scaling documentation: https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html
//example: https://geekdudes.wordpress.com/2018/01/10/amazon-autosclaing-using-terraform/

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
locals {
  kube-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.test-eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.test-eks.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

resource "aws_launch_configuration" "kube-nodes" {
  associate_public_ip_address = false
  key_name                    = "${var.kubenodes-public-key}"
  iam_instance_profile        = "${aws_iam_instance_profile.kube-node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks-node"
  security_groups             = ["${var.sg_kube_nodes_id}"]
  user_data_base64            = "${base64encode(local.kube-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

//Create AutoScaling Group
#https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html
resource "aws_autoscaling_group" "kube-nodes" {
  desired_capacity        = 3
  launch_configuration    = "${aws_launch_configuration.kube-nodes.id}"
  max_size                = 6
  min_size                = 3
  name                    = "terraform-eks-nodes"
  vpc_zone_identifier     = ["${var.subnet_pri_a_id}", "${var.subnet_pri_b_id}", "${var.subnet_pri_c_id}"]
  service_linked_role_arn = "${data.aws_iam_role.AWSServiceRoleForAutoScaling.arn}"

  #VERIFY THE ABOVE POLICY!

  tag {
    key                 = "Name"
    value               = "terraform-eks-nodes"
    propagate_at_launch = true
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
