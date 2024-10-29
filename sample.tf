data "external" "myjson" {
  program = [
    "kubergrunt eks oidc-thumbprint --issuer-url https://oidc.eks.us-east-1.amazonaws.com/id/0A0D0750871AD0E848F90F4ECC6ACBFF",
  ]
}
output "data" {
  value = data.external.myjson
}