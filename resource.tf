resource "aws_dynamodb_table" "this" {
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "LockID"
  name              = "${local.namespace}-terraform-locks"
  read_capacity     = 20
  write_capacity    = 20
 
  attribute {
    name            = "LockID"
    type            = "S"
  }

  point_in_time_recovery {
    enabled         = true
  }

  server_side_encryption {
    enabled         = true
    kms_key_arn     = module.key.key.arn
  }
}