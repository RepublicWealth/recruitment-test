
resource "aws_api_gateway_rest_api" "spitfire_recruitment" {
  name        = "SpitfireRecruitment"
  description = "API for the coding test"
}


resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.spitfire_recruitment.id}"
  parent_id   = "${aws_api_gateway_rest_api.spitfire_recruitment.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.spitfire_recruitment.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.spitfire_recruitment.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.test_lambda.invoke_arn}"
}


resource "aws_api_gateway_deployment" "spitfire_recruitment" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.spitfire_recruitment.id}"
  stage_name  = "test"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.spitfire_recruitment.invoke_url}"
}