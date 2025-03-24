output "dnsName" {
  description = "DNS name of ALB"
  value = aws_lb.alb.dns_name
}

output "albARN" {
  description = "ARN of ALB"
  value = aws_lb.alb.arn
}

output "jenkinscred" {
  value = "username/password: admin/admin"
}

output "jenkinsURL" {
  value = "http://98.80.210.120:8080/"
}
