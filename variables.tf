variable "region" {
  type = string
  default = "eu-west-1"
}

variable "application_name" {
  type = string
  default = "sonar-docker-app"
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "solution_stack_name" {
  type = string
  default = "64bit Amazon Linux 2023 v4.3.6 running Docker"
}