output "instance_type_used" {
  value = var.instance_type
}

output "tag_name_used" {
  value = var.aws_common_tag["Name"]
}
