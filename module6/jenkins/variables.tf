variable "region" {
  default = "us-west-2"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "profile_name" {
  default = "default"
}
variable "instance_key" {
  default = "install"
}
variable "vpc_cidr" {
  default = "10.0.0.0/24"
}
variable "public_subnet_cidr" {
  default = "10.0.10.0/25"
}
