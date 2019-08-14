# This outputs your kubeconfig for kubectl
locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo-eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo-eks.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

# Required Kubernetes Configuration to Join Worker Nodes
# The EKS service does not provide a cluster-level API parameter or resource
# to automatically configure the underlying Kubernetes cluster to allow worker
# nodes to join the cluster via AWS IAM role authentication.
locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.kube-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

# Create output files
resource "local_file" "kubeconfig" {
  content  = "${local.kubeconfig}"
  filename = "./output-files/eks/kubeconfig.yaml"
}

resource "local_file" "config-map-aws-auth" {
  content  = "${local.config-map-aws-auth}"
  filename = "./output-files/eks/config-map-aws-auth.yaml"
}
