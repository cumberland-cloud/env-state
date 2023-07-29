locals {
  namespace         = "cumberland-cloud"
  # NOTE: need to create the replication role manually until the state bucket is deployed
  replication_role  = {
    arn             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/s3-tfstate-replicator"
    id              = "s3-tfstate-replicator"
    name            = "s3-tfstate-replicator"
  }
}