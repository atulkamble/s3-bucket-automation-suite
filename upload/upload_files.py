# upload/upload_files.py
import boto3

s3 = boto3.client('s3')
bucket_name = "my-s3-file-manager-atulkamble"

s3.upload_file("sample.txt", bucket_name, "docs/sample.txt")
s3.upload_file("sample.txt", bucket_name, "sample.txt")
