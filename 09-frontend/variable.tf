variable "project_name" {
    default = "expense"
}
variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {

        Name = "Expense"
        Environment = "Dev"
        Terraform = true
        Component= "frontend"
    }
  
}
variable "zone_name" {
  default = "sdevops.cloud"
}