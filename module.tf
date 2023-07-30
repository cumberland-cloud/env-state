module "key" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  source            = "github.com/cumberland-cloud/modules-kms.git?ref=v1.0.0"

  key               = {
    alias           = "${local.namespace}-terraform-state"
  }
}

module "bucket" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  
  source            = "github.com/cumberland-cloud/modules-s3.git?ref=v1.0.0"

  bucket            = {
    name            = "${local.namespace}-terraform-state"
    key             = module.key.key
  }
  replication_role  = local.replication_role
}