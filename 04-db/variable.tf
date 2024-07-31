variable "Project_name" {
    default = "expense"
}
variable "environment" {
    default = "dev"
  
}
variable "db_sg_description" {
    default = "sg for DB mysql Instance"
  
}
variable "sg_name" {
    default = "dev"
  
}

variable "common_tags" {
    default = {

        Name = "Expense"
        Environment = "Dev"
        Terraform = true
    }
  
}
variable "zone_name" {
    default = "sdevops.cloud"
  
}