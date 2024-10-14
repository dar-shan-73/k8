resource "aws_eks_cluster" "example" {
  name     = "b58-eks"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = ["subnet-0d1a07bc7ceaf4694", "subnet-05a9dc77897b66c38", "subnet-08c53c78664626d0f"] # This is where nodes are going to be provisioned. This is a multi-zonal kubernetes cluster
  }

  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}



# Provisions Node Group and attachs this to the eks 
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "b58-eks-np-spot-0"
  node_role_arn   = aws_iam_role.node-example.arn
  subnet_ids      = ["subnet-0d1a07bc7ceaf4694", "subnet-05a9dc77897b66c38", "subnet-08c53c78664626d0f"]
  instance_types  = ["t3.medium", "t3.large"]
  capacity_type   = "SPOT"

  scaling_config {
    desired_size = 1 # when the cluster was provisioned this would be nodegroup node count
    max_size     = 3 # Maximum number of nodes that the node-group can scale
    min_size     = 1 # When the workloads are really less, this would be the number where nodegroup can scale down to.
  }
}


#  IAM Role for EKS Node Group
resource "aws_iam_role" "node-example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-example.name
}