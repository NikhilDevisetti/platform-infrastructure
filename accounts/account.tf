locals {
  sbt_releases_bucket_arn = "arn:aws:s3:::releases.mvn-repo.wellcomecollection.org"
}

# Parent Platform account

module "aws_account" {
  source = "./modules/account/aws"

  # 4 hours
  max_session_duration_in_seconds = 4 * 60 * 60

  prefix = "platform"

  principals = [
    local.account_principals["platform"],
  ]

  infra_bucket_arn        = "arn:aws:s3:::wellcomecollection-platform-infra"
  sbt_releases_bucket_arn = local.sbt_releases_bucket_arn
}

module "account_federation" {
  source = "./modules/account/federated"

  saml_xml = data.aws_s3_bucket_object.account_federation_saml.body
  pgp_key  = data.template_file.pgp_key.rendered

  prefix = "azure_sso"
}

data "aws_s3_bucket_object" "account_federation_saml" {
  bucket = "wellcomecollection-platform-infra"
  key    = "platform-terraform-objects/saml.xml"
}

# Child Platform Accounts

module "catalogue_account" {
  source = "./modules/account/aws"

  providers = {
    aws = aws.catalogue
  }

  prefix = "catalogue"
  principals = [
    local.account_principals["platform"],
    local.account_principals["catalogue"],
  ]

  infra_bucket_arn        = "arn:aws:s3:::wellcomecollection-catalogue-infra-delta"
  sbt_releases_bucket_arn = local.sbt_releases_bucket_arn
}
