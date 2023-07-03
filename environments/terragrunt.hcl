remote_state {
    backend = "s3"

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "terraform-terragrunt-states-bucket"
        key = "${path_relative_to_include()}/terraform.tfvars"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "dev-lock-table"
    }
}

