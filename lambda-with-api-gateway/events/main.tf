
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


data "archive_file" "zip_the_java_code" {
  type        = "zip"
  source_dir  = "../HelloWorldFunction"
  output_path = "target/HelloWorld-1.0.jar"
}


resource "aws_s3_objec" "file_upload" {
bucket = "bucket_files_lambda"
key = "terraform_lambda_function"
source = data.archive_file.zip_the_java_code.output_path
}


