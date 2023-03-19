
resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-bucket"
}

resource "aws_iam_role" "lambda_role" {
  name   = "Spacelift_Test_Lambda_Function_Role"
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

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
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
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}


resource "aws_lambda_function" "terraform_lambda_func" {
  filename                       = "${path.module}/../HelloWorldFunction/target/HelloWorld-1.0.jar"
  function_name                  = "HelloWorldTerraform"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "helloworld.App"
  runtime                        = "java11"
  depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

}
/*

ENDPOINT=http://localhost:4567/restapis/7cs7led7z6/dev
http://7cs7led7z6.execute-api.localhost.localstack.cloud:4566/dev/
*/
