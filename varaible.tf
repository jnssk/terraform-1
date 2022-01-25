#cli
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
#vpc
variable "vpc_cidr" {}

variable "vpc_name" {}
#igw
variable "igw_name" {}
#subnets
variable "subnet_cidr" {}
variable "azs" {}
#route table
variable "pub_rt_name" {}

#instance

variable "imagename" {
   type = map
   default = {
     us-east-1 = "ami-083654bd07b5da81d"
     us-east-2 = "ami-0629230e074c580f2"
   }
}
