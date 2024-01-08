resource "aws_iam_role" "node" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = <<POLICY
        {
            Version = "2012-10-17"
            Statement = [
                {
                    Action = "sts:AssumeRole"
                    Effect = "Allow"
                    Principal = {
                        Service = "ec2.amazonaws.com"
                    }
                }
            ]
        }
    POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_eks_node_group" "node-1" {
    cluster_name    = aws_eks_cluster.cluster-eks.name
    node_group_name = "${var.cluster_name}-node-1"
    node_role_arn   = aws_iam_role.node.arn
    subnet_ids      = aws_subnet.subnet[*].id

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
