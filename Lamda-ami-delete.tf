resource "aws_lambda_function" "deregister_ami" {
  filename         = "lambda_function.zip"
  function_name    = "deregister_ami_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "python3.8"
  timeout          = 30  # Increase the timeout to 30 seconds

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      AMI_IDS = jsonencode(var.ami_ids)
    }
  }
}

resource "aws_lambda_invocation" "invoke_lambda" {
  function_name = aws_lambda_function.deregister_ami.function_name

  input = jsonencode({
    ami_ids = var.ami_ids
  })

  depends_on = [
    aws_lambda_function.deregister_ami
  ]
}
