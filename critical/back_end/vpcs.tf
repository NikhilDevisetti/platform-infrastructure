locals {
  storage_cidr_block_vpc     = "172.30.0.0/16"
  storage_cidr_block_public  = cidrsubnet(local.storage_cidr_block_vpc, 1, 0)
  storage_cidr_block_private = cidrsubnet(local.storage_cidr_block_vpc, 1, 1)

  monitoring_cidr_block_vpc     = "172.28.0.0/16"
  monitoring_cidr_block_public  = cidrsubnet(local.monitoring_cidr_block_vpc, 1, 0)
  monitoring_cidr_block_private = cidrsubnet(local.monitoring_cidr_block_vpc, 1, 1)

  datascience_cidr_block_vpc     = "172.17.0.0/16"
  datascience_cidr_block_public  = cidrsubnet(local.datascience_cidr_block_vpc, 1, 0)
  datascience_cidr_block_private = cidrsubnet(local.datascience_cidr_block_vpc, 1, 1)

  developer_cidr_block_vpc     = "172.42.0.0/16"
  developer_cidr_block_public  = cidrsubnet(local.developer_cidr_block_vpc, 1, 0)
  developer_cidr_block_private = cidrsubnet(local.developer_cidr_block_vpc, 1, 1)

  ci_cidr_block_vpc     = "172.43.0.0/16"
  ci_cidr_block_public  = cidrsubnet(local.ci_cidr_block_vpc, 1, 0)
  ci_cidr_block_private = cidrsubnet(local.ci_cidr_block_vpc, 1, 1)
}

module "developer_vpc" {
  source = "./modules/public-private-igw"

  name = "developer-172-42-0-0-16"

  cidr_block_vpc = local.developer_cidr_block_vpc

  public_az_count           = "3"
  cidr_block_public         = local.developer_cidr_block_public
  cidrsubnet_newbits_public = "2"

  private_az_count           = "3"
  cidr_block_private         = local.developer_cidr_block_private
  cidrsubnet_newbits_private = "2"

  providers = {
    aws = aws.platform
  }
}

module "ci_vpc" {
  source = "./modules/public-private-igw"

  name = "ci-172-43-0-0-16"

  cidr_block_vpc = local.ci_cidr_block_vpc

  public_az_count           = "3"
  cidr_block_public         = local.ci_cidr_block_public
  cidrsubnet_newbits_public = "2"

  private_az_count           = "3"
  cidr_block_private         = local.ci_cidr_block_private
  cidrsubnet_newbits_private = "2"

  providers = {
    aws = aws.platform
  }
}

module "storage_vpc" {
  source = "./modules/public-private-igw"

  name = "storage-172-30-0-0-16"

  cidr_block_vpc = local.storage_cidr_block_vpc

  public_az_count           = "3"
  cidr_block_public         = local.storage_cidr_block_public
  cidrsubnet_newbits_public = "2"

  private_az_count           = "3"
  cidr_block_private         = local.storage_cidr_block_private
  cidrsubnet_newbits_private = "2"

  providers = {
    aws = aws.storage
  }
}

# Used by:
# - Grafana service
# - Various monitoring lambdas

module "monitoring_vpc_delta" {
  source = "./modules/public-private-igw"

  name = "monitoring-172-28-0-0-16"

  cidr_block_vpc = local.monitoring_cidr_block_vpc

  public_az_count           = "3"
  cidr_block_public         = local.monitoring_cidr_block_public
  cidrsubnet_newbits_public = "2"

  private_az_count           = "3"
  cidr_block_private         = local.monitoring_cidr_block_private
  cidrsubnet_newbits_private = "2"

  providers = {
    aws = aws.platform
  }
}

# Used by:
# - Data science service
# - Labs apps & data scientist infra

module "datascience_vpc" {
  source = "./modules/public-private-igw"

  name = "datascience-172-17-0-0-16"

  cidr_block_vpc = local.datascience_cidr_block_vpc

  public_az_count           = "3"
  cidr_block_public         = local.datascience_cidr_block_public
  cidrsubnet_newbits_public = "2"

  private_az_count           = "3"
  cidr_block_private         = local.datascience_cidr_block_private
  cidrsubnet_newbits_private = "2"

  providers = {
    aws = aws.datascience
  }
}
