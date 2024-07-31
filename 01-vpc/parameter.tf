
resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_id"
  type  = "StringList"
  value = join("," ,module.vpc.public_subnet_ids) #converting list to string list
}
# ["ID1","ID2"] this type of list is terraform format
#id1, id2 this type of list is AWS format
resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_id"
  type  = "StringList"
  value = join("," ,module.vpc.private_subnet_ids) #converting list to string list
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_id"
  type  = "StringList"
  value = join("," ,module.vpc.database_subnet_ids) #converting list to string list
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}

