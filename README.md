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
bucket_name = "my-s3-file-manager-atulkamble"

s3.upload_file("sample.txt", bucket_name, "docs/sample.txt")
s3.upload_file("sample.txt", bucket_name, "sample.txt")
```

---

### 5. ⚙️ **Setup S3 Event Trigger with Lambda**


## 🔧 Step 5.1: **Create the Lambda Function**

**File:** `lambda/lambda_function.py`

```python
def lambda_handler(event, context):
    for record in event['Records']:
        print("New file uploaded:", record['s3']['object']['key'])
```

---

## 🚀 Step 5.2: **Package Lambda for Deployment**

Zip the Lambda code:

```bash
cd lambda
zip lambda_function.zip lambda_function.py
```

---

## ☁️ Step 5.3: **Create Lambda Function via AWS CLI**

```bash
aws lambda create-function \
  --function-name processFileUpload \
  --runtime python3.9 \
  --role arn:aws:iam::535002879962:role/lambda-s3-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda_function.zip \
  --region us-east-1
```

---

## 📤 Step 5.4: **Add S3 Event Notification to Trigger Lambda**

Create this JSON file as `event-notification.json`:

```json
{
  "LambdaFunctionConfigurations": [
    {
      "LambdaFunctionArn": "arn:aws:lambda:us-east-1:<your-account-id>:function:processFileUpload",
      "Events": ["s3:ObjectCreated:*"]
    }
  ]
}
```

Then update your S3 bucket notification:

```bash
aws s3api put-bucket-notification-configuration \
  --bucket my-s3-file-manager-atulkamble \
  --notification-configuration file://event-notification.json
```

---

## 👮 Step 5.5: **Create IAM Role for Lambda**

1. **Create Trust Policy (trust-policy.json):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "lambda.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. **Create Role:**

```bash
aws iam create-role \
  --role-name lambda-s3-role \
  --assume-role-policy-document file://trust-policy.json
```

3. **Attach Inline Policy:**

Create `lambda-s3-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

Attach it:

```bash
aws iam put-role-policy \
  --role-name lambda-s3-role \
  --policy-name lambda-s3-policy \
  --policy-document file://lambda-s3-policy.json
```

---

## 🪣 Step 5.6: **Add Bucket Policy to Allow Lambda Access**

Update S3 bucket policy:

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
      "Resource": "arn:aws:s3:::my-s3-file-manager-atulkamble/*"
    }
  ]
}
```

Apply it:

```bash
aws s3api put-bucket-policy \
  --bucket my-s3-file-manager-atulkamble \
  --policy file://bucket-policy.json
```

---

## ✅ Test Your Setup

Upload a file:

```bash
aws s3 cp testfile.txt s3://my-s3-file-manager-atulkamble/
```

Check **CloudWatch Logs** to see if Lambda logged the file upload.

---

Let me know if you'd like to automate these steps in a script or Terraform!




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
