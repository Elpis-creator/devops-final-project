
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 SSH key pair"
  type        = string
  default     = "devops-key"
}

variable "allowed_cidr" {
  description = "Your public IP address in CIDR format"
  type        = string
}
