provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-east-1"
    # Assign the profile name here!
    profile = "default"
}

