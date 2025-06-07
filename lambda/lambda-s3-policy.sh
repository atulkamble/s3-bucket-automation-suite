aws iam put-role-policy \
  --role-name lambda-s3-role \
  --policy-name lambda-s3-permissions \
  --policy-document file://lambda-s3-policy.json
