This script file include a resource group, virtual networks, 2-pblic subnet, 2-private subnet, AKS Cluster a node pool in private subnet, and a public load balancer

Prerequisites
  1. Terraform installed
  2. Azure CLI configured and authenticated
  3. Replace place holder <location> in local.tf file

Test and deploy using 
  1. terraform init
  2. terraform validate
  3. terraform plan -out=tfplan.out
  4. terraform apply tfplan.out

Cleaning up
  terraform destroy
