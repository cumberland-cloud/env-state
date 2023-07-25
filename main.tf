module "key" {
  source            = "../modules/kms"

  key               = {
    alias           = "cumberland-cloud-gateway-state"
  }
}

module "bucket" {
  source            = "../modules/s3"

  bucket            = {
    name            = "cumberland-cloud-gateway-terraform-state"
    kms_key_arn     = module.key.arn
  }
}

resource "aws_dynamodb_table" "this" {
  name              = "cumberland-cloud-gateway-terraform-lock"
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