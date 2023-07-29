module "key" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash"

  source            = "github.com/cumberland-cloud/modules-kms.git?ref=v1.0.0"

  key               = {
    alias           = "${local.namespace}-state"
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

resource "aws_dynamodb_table" "this" {
  name              = "${local.namespace}-terraform-locks"
  hash_key          = "LockID"
  read_capacity     = 20
  write_capacity    = 20
 
  attribute {
    name            = "LockID"
    type            = "S"
  }

  server_side_encryption {
    enabled         = true
    kms_key_arn     = module.key.key.arn
  }
}