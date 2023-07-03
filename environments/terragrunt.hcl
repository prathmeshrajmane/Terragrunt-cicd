remote_state {
    backend = "s3"

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "prathm-testing-states-bucket"
        key = "${path_relative_to_include()}/terraform.tfvars"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "dev-lock-table"
    }
}

terraform {
    extra_arguments "bucket" {
        commands = get_terraform_commands_that_need_vars()
        optional_var_files = [
            find_in_parent_folders("environments.tfvars", "ignore")
        ]
    }
}
