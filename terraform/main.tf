provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

terraform {
  backend "s3" {
    bucket = "imdevinc-tf-storage"
    region = "us-west-1"
    key    = "gnomebytes"
  }
}
