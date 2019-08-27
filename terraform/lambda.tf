variable "aws_region" {
  default = "us-west-2"
}

provider "aws" {
  region          = "${var.aws_region}"
}


data "template_file" "index_js" {
  template = "${file("../api/index.js")}"
}
data "template_file" "brokerage_js" {
  template = "${file("../api/brokerage.js")}"
}
data "template_file" "list_js" {
  template = "${file("../api/list.js")}"
}
data "template_file" "instruments_json" {
  template = "${file("../api/instruments.json")}"
}


data "archive_file" "lambda_zip" {
  type = "zip"

  source {
    content  = "${data.template_file.index_js.rendered}"
    filename = "index.js"
  }

  source {
    content  = "${data.template_file.brokerage_js.rendered}"
    filename = "brokerage.js"
  }

  source {
    content  = "${data.template_file.list_js.rendered}"
    filename = "list.js"
  }

  source {
    content  = "${data.template_file.instruments_json.rendered}"
    filename = "instruments.json"
  }

  output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "index.handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "nodejs10.x"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
            "logs:CreateLogGroup",
             "logs:CreateLogStream",
             "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.iam_for_lambda_tf.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}


resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.spitfire_recruitment.execution_arn}/*/*"
}
