aws lambda add-permission \
  --function-name processFileUpload \
  --principal s3.amazonaws.com \
  --statement-id S3InvokeLambdaPermission \
  --action "lambda:InvokeFunction" \
  --source-arn arn:aws:s3:::my-s3-file-manager-atulkamble
