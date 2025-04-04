resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = "/nginx/logs"
  retention_in_days = 30
}
