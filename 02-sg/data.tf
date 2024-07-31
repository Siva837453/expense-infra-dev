data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.Project_name}/${var.environment}/vpc_id"
}