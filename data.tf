data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "state" {
    statement {
        sid             = "AllowS3Actions"
        effect          = "Allow"
        actions         = [
            "s3:Get*",
            "s3:List*"
        ]
        resources       = local.bucket_arns
    }

    statement {
        sid             = "DenyS3Actions"
        effect          = "Deny"
        actions         = [
            "s3:Delete*",
            "s3:PutBucketAcl",
            "s3:PutObjectAcl",
            "s3:PutObjectVersionAcl"
        ]
        resources       = local.bucket_arns
    }

    statement {
        sid             = "AllowDynamoActions"
        effect          = "Allow"
        actions         = [
            "dynamodb:PutItem",
            "dynamodb:GetItem",
            "dynamodb:DeleteItem"
        ]
        resources       = [ aws_dynamodb_table.this.arn ]
    }

    statement {
        sid             = "AllowKMSActions"
        effect          = "Allow"
        actions         = [
            "kms:DescribeKey",
            "kms:GenerateDataKey",
            "kms:Decrypt"    
        ]
        resources       = [ module.key.key.arn ]
    }
}