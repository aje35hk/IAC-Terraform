module "vpc" {
  source               = "../modules/vpc"
  project              = var.project
  cidr_block           = "10.1.0.0/16"
  subnet_cidrs_private = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  subnet_cidrs_public  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  availability_zone    = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  igw                  = true
  ngw                  = false
}
