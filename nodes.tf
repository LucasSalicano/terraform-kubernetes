resource "aws_iam_role" "node" {
  name               = "${var.prefix}-${var.cluster_name}-role-node"
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

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_eks_node_group" "node-1" {
  cluster_name    = aws_eks_cluster.cluster-eks.name
  node_group_name = "${var.cluster_name}-node-1"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.subnets[*].id
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.cluster-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSWorkerNodePolicy,
  ]
}

resource "aws_eks_node_group" "node-2" {
  cluster_name    = aws_eks_cluster.cluster-eks.name
  node_group_name = "${var.cluster_name}-node-1"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.subnets[*].id
  instance_types  = ["t2.micro"]
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.cluster-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSWorkerNodePolicy,
  ]
}
