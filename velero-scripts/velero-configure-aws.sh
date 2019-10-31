#!/bin/bash
# Configuring Velero for a Kubernetes cluster hosted in AWS
# For in depth details, check https://heptio.github.io/velero/master/aws-config.html

export VELERO_FOLDER=/opt/velero/
export BUCKET_NAME=k8s-cluster-velero # Use a different name
export CLOUD_REGION=us-east-1


# Create an S3 bucket to store Object backups
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $CLOUD_REGION

# Create Velero IAM user
aws iam create-user --user-name velero

# Attach IAM policies
cat > $VELERO_FOLDER/velero-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}"
            ]
        }
    ]
}
EOF

aws iam put-user-policy \
  --user-name velero \
  --policy-name velero \
  --policy-document file://${VELERO_FOLDER}/velero-policy.json

# Create IAM credentials
export CREDENTIALS_OUTPUT=$(aws iam create-access-key --user-name velero)

export VELERO_AWS_ACCESS=$(echo -n "$CREDENTIALS_OUTPUT" | jq -r '.AccessKey.AccessKeyId')
export VELERO_AWS_SECRET=$(echo -n "$CREDENTIALS_OUTPUT" | jq -r '.AccessKey.SecretAccessKey')

# Create "credentials-velero" file
cat > $VELERO_FOLDER/credentials-velero <<EOF
[default]
aws_access_key_id=${VELERO_AWS_ACCESS}
aws_secret_access_key=${VELERO_AWS_SECRET}
EOF
