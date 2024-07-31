variable "project_name" {
    default = "expense"
}
variable "environment" {
    default = "dev"
}
variable "sg_name" {
    default = "dev"
  
}

variable "common_tags" {
    default = {

        Name = "Expense"
        Environment = "Dev"
        Terraform = true
        Component = "web-alb"
    }
  
}

variable "zone_name" {
    default = "sdevops.cloud"
  
}