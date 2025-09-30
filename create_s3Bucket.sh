#!/bin/bash

# A script to create and manage S3 buckets for different departments.

# --- Global Variables ---

# Define a company name as prefix
COMPANY_NAME="datawise"
# Array of department names
DEPARTMENTS=("marketing" "sales" "hr" "operations" "media")
# Default AWS region
AWS_REGION="eu-north-1"

# --- Functions ---

# Function to check for AWS CLI
check_aws_cli() {
    echo "Checking for AWS CLI..."
    if ! command -v aws &> /dev/null; then
        echo "Error: AWS CLI is not installed. Please install it to proceed."
        exit 1
    fi
    echo "AWS CLI found."
}

# Function to create S3 buckets
create_s3_buckets() {
    echo "Creating S3 buckets for each department..."
    for department in "${DEPARTMENTS[@]}"; do
        # Use lowercase for bucket names as per S3 naming conventions
        local bucket_name="${COMPANY_NAME}-${department}-data-bucket"
        echo "Attempting to create bucket: $bucket_name..."

        # Create S3 bucket using AWS CLI
        aws s3api create-bucket \
        --bucket "$bucket_name" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint=eu-north-1

        if [ $? -eq 0 ]; then
            echo "Successfully created S3 bucket: $bucket_name."
        else
            echo "Failed to create S3 bucket: $bucket_name. It may already exist."
        fi
    done
}

# Function to list S3 buckets with the specified prefix
list_s3_buckets() {
    echo "Listing S3 buckets with the prefix '${COMPANY_NAME}'..."
    aws s3api list-buckets --query "Buckets[?starts_with(Name, '${COMPANY_NAME}-')].Name" --output table
}

# Function to delete all S3 buckets with a specified prefix
delete_s3_buckets() {
    echo "Warning: This will permanently delete all S3 buckets with the prefix '${COMPANY_NAME}'. This action cannot be undone."
    read -p "Are you sure you want to proceed? (yes/no): " confirmation
    if [[ "$confirmation" != "yes" ]]; then
        echo "Operation cancelled."
        return
    fi

    echo "Deleting S3 buckets with prefix '${COMPANY_NAME}'..."
    buckets_to_delete=$(aws s3api list-buckets --query "Buckets[?starts_with(Name, '${COMPANY_NAME}-')].Name" --output text)

    if [ -z "$buckets_to_delete" ]; then
        echo "No buckets found to delete."
        return
    fi

    for bucket in $buckets_to_delete; do
        echo "Deleting contents of bucket: $bucket..."
        aws s3 rm "s3://$bucket" --recursive &> /dev/null

        echo "Deleting bucket: $bucket..."
        aws s3api delete-bucket --bucket "$bucket" &> /dev/null
        
        if [ $? -eq 0 ]; then
            echo "Successfully deleted bucket: $bucket."
        else
            echo "Failed to delete bucket: $bucket."
        fi
    done
}