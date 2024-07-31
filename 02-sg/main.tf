module "db" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for DB mysql Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
  common_tags = var.common_tags
  
}


module "backend" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for backend mysql Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
  common_tags = var.common_tags
  
}

module "frontend" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for frontend mysql Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
  common_tags = var.common_tags
  
}

module "bastion" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for bastion mysql Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
  common_tags = var.common_tags
  
}


module "app_alb" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for app alb Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app_alb"
  common_tags = var.common_tags
  
}
module "vpn" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for vpn Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "vpn"
  common_tags = var.common_tags
  inbound_rules = var.vpn_sg_rules
  
}

module "web_alb" {
  source = "../../expense-aws-securitygroup"
  project_name = var.Project_name
  environment = var.environment
  sg_description = "sg for web alb Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web_alb"
  common_tags = var.common_tags

  
}


# DB is accepting connection from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id  # source is where you are getting traffic
  security_group_id = module.db.sg_id
}

# DB is accepting connection from bastion
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic
  security_group_id = module.db.sg_id
}

# DB is accepting connection from vpn
resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic
  security_group_id = module.db.sg_id
}
# backend is accepting connection from app_alb
resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id  # source is where you are getting traffic
  security_group_id = module.backend.sg_id
}

# backend is accepting connection from bastion
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic
  security_group_id = module.backend.sg_id
}

# backend is accepting connection from vpn ssh
resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic
  security_group_id = module.backend.sg_id
}

# backend is accepting connection from vpn http
resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic
  security_group_id = module.backend.sg_id
}

# app alb is accepting connection from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  # source is where you are getting traffic
  security_group_id = module.app_alb.sg_id
}

# app alb is accepting connection from bastion
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic
  security_group_id = module.app_alb.sg_id
}

# app alb is accepting connection from frontend
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id  # source is where you are getting traffic
  security_group_id = module.app_alb.sg_id
}


# frontend is accepting connection from vpn
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic
  security_group_id = module.frontend.sg_id
}

# frontend is accepting connection from bastion
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  # source is where you are getting traffic
  security_group_id = module.frontend.sg_id
}
# frontend is accepting connection from web alb
resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id  # source is where you are getting traffic
  security_group_id = module.frontend.sg_id
}

# web alb  is accepting connection from public
resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source is where you are getting traffic
  security_group_id = module.web_alb.sg_id
}

# web alb  is accepting connection from public https
resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source is where you are getting traffic
  security_group_id = module.web_alb.sg_id
}

# bastion is accepting connection from public
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # source is where you are getting traffic
  security_group_id = module.bastion.sg_id
}


# not required, we can connect from VPN
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id
# }