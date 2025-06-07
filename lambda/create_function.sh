aws lambda create-function \
  --function-name processFileUpload \
  --runtime python3.9 \
  --role arn:aws:iam::535002879962:role/lambda-s3-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda_function.zip \
  --region us-east-1
