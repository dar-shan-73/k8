# Provisions Node Group and attachs this to the eks 
resource "aws_eks_node_group" "example" {
  depends_on      = [aws_eks_addon.example] # CNI has to be enabled on the cluster first and then node-pool provisioning
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "b58-eks-np-spot-0"

  node_role_arn  = aws_iam_role.node-example.arn
  subnet_ids     = ["subnet-0d1a07bc7ceaf4694", "subnet-05a9dc77897b66c38", "subnet-08c53c78664626d0f"]
  instance_types = ["t3.medium", "t3.large"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 2 # when the cluster was provisioned this would be nodegroup node count
    max_size     = 4 # Maximum number of nodes that the node-group can scale
    min_size     = 2 # When the workloads are really less, this would be the number where nodegroup can scale down to.
  }
  tags = {
    Environment = "Test"
    project     = "expense"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
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






### Crreating IAM Policy
resource "aws_iam_policy" "cluster_autoscale" {
  name        = "cluster_autoscale"
  path        = "/"
  description = "cluster_autoscale"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource" : ["*"]
      }
    ]
  })
}

# attaching this policy to node-example role
resource "aws_iam_role_policy_attachment" "cluster_autoscale" {
  policy_arn = aws_iam_policy.cluster_autoscale.arn
  role       = aws_iam_role.node-example.name
}