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


#**************************************
# attaching this policy to node-example role
resource "aws_iam_role_policy_attachment" "cluster_autoscale" {
  policy_arn = aws_iam_policy.cluster_autoscale.arn
  role       = aws_iam_role.node-example.name
}

# Extracting the info of thumbprint
data "external" "myjson" {
  program = [
    "kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", "${aws_eks_cluster.example.identity[0].oidc[0].issuer}"
  ]
}
output "data" {
  value = data.external.myjson.result.thumbprint
}

# 000 - Creates OIDC Connector for EKS using the EKS OIDC Thumbprint
resource "aws_iam_openid_connect_provider" "default" {
  url = aws_eks_cluster.example.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [data.external.myjson.result.thumbprint]
}

# Create IAM Role that can be federated by the k8 sa for assuming

resource "aws_iam_role" "eks_cluster_autoscale" {
  name = "eks_cluster_autoscale"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::355449129696:oidc-provider/oidc.eks.region-code.amazonaws.com/id/${local.eks_client_id}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.region-code.amazonaws.com/id/${local.eks_client_id}:sub" : "system:serviceaccount:default:default",
            "oidc.eks.region-code.amazonaws.com/id/${local.eks_client_id}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    tag-key = "eks_cluster_autoscale"
  }
}

# Atatching this IAM Role to IAM Policy cluster_autoscale (Giving  k8 SA access to IAM Role that has node launch privilege )
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscale.arn
  role       = aws_iam_role.eks_cluster_autoscale.name
}

locals {
  eks_client_id = element(tolist(split("/", tostring(aws_eks_cluster.example.identity[0].oidc[0].issuer))), 4)
}

# 001 - assign the OIDC Provider to EKS
resource "aws_eks_identity_provider_config" "oidc" {
  cluster_name = aws_eks_cluster.example.name

  oidc {
    client_id                     = local.eks_client_id
    identity_provider_config_name = "iam-oidc"
    issuer_url                    = aws_iam_openid_connect_provider.default.url
  }
}
