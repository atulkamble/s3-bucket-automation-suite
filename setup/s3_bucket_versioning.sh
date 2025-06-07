aws s3api put-bucket-versioning \
  --bucket my-s3-file-manager-atulkamble \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket my-s3-file-manager-atulkamble \
  --server-side-encryption-configuration '{
      "Rules": [
        {
          "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
          }
        }
      ]
    }'
