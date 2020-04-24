variable "rds_engine_type" {
  type        = string
  default     = "mysql"
  description = "The RDS engine type to use"
}

variable "rds_engine_version" {
  type        = string
  description = "The RDS engine version to use"
}

variable "username" {
  type        = string
  description = "Username for RDS"
}

variable "password" {
  type        = string
  description = "Password for RDS"
}

variable "rds_security_group" {
  type        = string
  description = "Security group of the RDS"
}

variable "rds_subnet_group_ids" {
  type        = list(string)
  description = "Subnets ID to deploy RDS into"
}

