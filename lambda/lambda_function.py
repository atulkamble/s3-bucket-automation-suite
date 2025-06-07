# lambda/lambda_function.py
def lambda_handler(event, context):
    for record in event['Records']:
        print("New file uploaded:", record['s3']['object']['key'])
