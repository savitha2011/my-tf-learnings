module "ec2" {
  source   = "./modules/ec2"
  subnetid = module.vpc.subnetID
  vpcid    = module.vpc.vpcID
}

module "vpc" {
  source = "./modules/vpc"
}

module "asg" {
  source    = "./modules/ASG"
  subnetid  = module.vpc.subnetID
  subnetid2 = module.vpc.subnetID2
  vpcid     = module.vpc.vpcID
  websg     = module.ec2.aws_security_group_id
}

