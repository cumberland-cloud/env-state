resource "aws_dynamodb_table" "this" {
  billing_mode      = "PAY_PER_REQUEST"
  hash_key          = "LockID"
  name              = "${local.namespace}-terraform-locks"
 
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



resource "aws_iam_policy" "this" {
    name                    = "${local.namespace}-terraform-state-policy"
    description             = "Identity-based policy enabled access to Terraform State S3 Bucket"
    policy                  = data.aws_iam_policy_document.state.json
}