data "aws_ssm_parameter" "db_sg_id" {
  name = "/${var.Project_name}/${var.environment}/db_sg_id"
}

data "aws_ssm_parameter" "db_subnet_group_name" {
  name = "/${var.Project_name}/${var.environment}/db_subnet_group_name"
}

