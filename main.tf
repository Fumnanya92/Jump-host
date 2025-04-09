# Backend configuration for Terraform state management
# terraform {
#   backend "s3" {
#     bucket         = "bastion-new" # Replace with your bucket name
#     key            = "terraform/terraform.tfstate"     # Replace with a custom path
#     region         = "us-west-2"                       # Replace with your bucket region
#     dynamodb_table = "bastiondb" # Replace with your DynamoDB table name or you may not need it 
#     encrypt        = true                              # Enable encryption for added security
#   }
# }

# Call the VPC module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2

  nat_gateway_ip = var.nat_gateway_ip
}

# Call the Security Groups module
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id        = module.vpc.vpc_id
  tags          = var.tags
  bastion_sg_id = module.security_groups.bastion_sg_id # Pass the bastion_sg_id
}

# Call the EC2 module
module "ec2" {
  source                 = "./modules/ec2"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_1_id
  private_subnet_id      = module.vpc.private_subnet_1_id
  key_pair_name          = var.key_pair_name
  private_key_path       = var.private_key_path
  iam_instance_profile   = module.iam.iam_instance_profile_name
  vpc_security_group_ids = [module.security_groups.bastion_sg_id, module.security_groups.private_sg_id] # Include private_sg_id
  instance_type = var.instance_type
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

# Call the ALB module
module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  alb_security_group_id = module.security_groups.alb_sg_id
  private_instance_ids  = module.ec2.private_instance_ids
  s3_bucket_id          = module.s3.s3_bucket_id
}

module "iam" {
  source = "./modules/iam"
}
