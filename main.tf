module "ec2" {
  source   = "./modules/ec2"
  subnetid = module.vpc.subnetID
  vpcid    = module.vpc.vpcID
}

module "vpc" {
  source = "./modules/vpc"
}