output "base_url_localstack" {
  value = "http://${aws_api_gateway_deployment.example.rest_api_id}.execute-api.localhost.localstack.cloud:4566/${aws_api_gateway_deployment.example.stage_name}"
}

output "base_url_default_aws" {
  value = aws_api_gateway_deployment.example.invoke_url
}
