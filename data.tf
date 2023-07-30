data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "platform" { # TODO: policy for tenant access
    statement {
        sid             = "TFStatePerms"
        effect          = "Allow"
        actions         = [
            "s3:Get*",
            "s3:List*"
        ]
        resources       = local.bucket_arns

        principals {
            type        =  "AWS"
            identifiers = [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            ]
        }
    }

    statement {
        sid         = "DenyACLActions"
        effect      = "Deny"
        actions     = [
            "s3:Delete*",
            "s3:PutBucketAcl",
            "s3:PutObjectAcl",
            "s3:PutObjectVersionAcl"
        ]
        resources   = local.bucket_arns
  }
}