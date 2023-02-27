provider "aws" {
  region = "us-east-1"
  # Assign the profile name here!
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
}

