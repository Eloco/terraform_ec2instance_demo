provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "us-east-1"
    # Assign the profile name here!
    profile = "default"
}
