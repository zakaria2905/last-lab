output "ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.my-first-ec2-instance.*.public_ip
}