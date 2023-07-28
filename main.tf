locals {
  namespace         = "cumberland-cloud"
}

module "key" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  source            = "https://github.com/cumberland-cloud/modules-kms.git?ref=v1.0.0"

  key               = {
    alias           = "${local.project}-state"
  }
}

module "bucket" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"
  
  source            = "https://github.com/cumberland-cloud/modules-s3.git?ref=v1.0.0"

  bucket            = {
    name            = "${local.project}-terraform-state"
    key             = module.key.arn
  }
}

resource "aws_dynamodb_table" "this" {
  name              = "${local.project}-terraform-locks"
  hash_key          = "LockID"
  read_capacity     = 20
  write_capacity    = 20
 
  attribute {
    name            = "LockID"
    type            = "S"
  }

  server_side_encryption {
    enabled         = true
    kms_key_arn     = module.key.arn
  }
}