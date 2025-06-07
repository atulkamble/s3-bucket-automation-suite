**S3-based project** that demonstrates real-world use of Amazon S3 for file storage, management, access control, and automation using AWS CLI, SDK (Python Boto3), IAM, and optionally, Lambda for automation.

---

## 🔧 **Project Title:**

**"S3-Based File Management and Event Automation System"**

---

## 📌 **Project Overview:**

Build a robust system using Amazon S3 to:

* Host and manage files (e.g., logs, images, documents)
* Set up fine-grained access controls
* Implement versioning and lifecycle policies
* Automate processing using AWS Lambda when new files are uploaded

---

## 📁 **Project Structure:**

```
s3-project/
│
├── setup/
│   ├── create_s3_bucket.sh
│   └── attach_bucket_policy.sh
│
├── lambda/
│   ├── lambda_function.py
│   └── requirements.txt
│
├── upload/
│   └── upload_files.py
│
└── README.md
```

---

## 🚀 **Step-by-Step Project Breakdown**

---

### 1. ✅ **Create the S3 Bucket**

```bash
aws s3api create-bucket \
  --bucket my-s3-file-manager-atulkamble \
  --region us-east-1
```

---

### 2. 🔒 **Enable Versioning & Encryption**

```bash
aws s3api create-bucket \
  --bucket my-s3-file-manager-atulkamble \
  --region us-east-1
atul@MacBook setup % cat s3_bucket_versioning.sh 
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
```

---

### 3. 🧹 **Lifecycle Policy (Auto Archive/Delete)**

```json
# lifecycle.json
{
  "Rules": [
    {
      "ID": "Archive old files",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket my-s3-file-manager-atulkamble \
  --lifecycle-configuration file://lifecycle.json
```

---

### 4. 🧪 **Upload Files via Boto3 (Python)**

```python
# upload/upload_files.py
import boto3

s3 = boto3.client('s3')
bucket_name = "my-s3-file-manager-your-name"

s3.upload_file("sample.txt", bucket_name, "docs/sample.txt")
```

---

### 5. ⚙️ **Setup S3 Event Trigger with Lambda**

#### Create a Lambda function to process uploads:

```python
# lambda/lambda_function.py
def lambda_handler(event, context):
    for record in event['Records']:
        print("New file uploaded:", record['s3']['object']['key'])
```

#### Add S3 event notification trigger (JSON):

```json
{
  "LambdaFunctionConfigurations": [
    {
      "LambdaFunctionArn": "arn:aws:lambda:region:account-id:function:processFileUpload",
      "Events": ["s3:ObjectCreated:*"]
    }
  ]
}
```

---

### 6. 👮 **IAM Policy for S3 and Lambda Permissions**

#### IAM Role for Lambda

Attach a policy allowing:

* `s3:GetObject`
* `s3:PutObject`
* `logs:CreateLogGroup`
* `logs:CreateLogStream`
* `logs:PutLogEvents`

#### Bucket Policy Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-s3-file-manager-your-name/*"
    }
  ]
}
```

---

## 📊 **Optional Add-ons**

* **Static Website Hosting on S3**
* **CloudFront CDN for global access**
* **Athena integration for querying logs**
* **SNS or SES notification on file upload**

---

## 📘 **README.md Sample Content**

```md
# S3-Based File Management and Event Automation System

## Features
- Upload and manage files securely
- Version control, lifecycle policy, and encryption
- Automatic trigger of Lambda functions on file uploads

## Setup Instructions
1. Create the S3 bucket and configure it
2. Upload files manually or via script
3. Deploy Lambda and configure event notifications
```

---
