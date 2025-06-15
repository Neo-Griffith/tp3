variable "instance_type" {
  type = string
  description = "Set AWS EC2 instance type"
  default = "t2.nano"
}

variable "aws_common_tag" {
  type = map(string)
  description = "Set AWS tag"
  default = {
    Name = "ec2-coco"
  }
}