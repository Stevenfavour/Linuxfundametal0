#!/bin/bash

# A script to create and manage EC2 instances based on user-provided arguments.

# --- Global Variables ---

# Define global variables for instance parameters
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0cd59ecaf368e5ccf"
REGION="eu-north-1"
KEY_PAIR_NAME="MyKeyPair"
TAGS="Key=Project,Value=Moniepoint"

# --- Functions ---

# Function to check for AWS CLI and configure environment
check_prerequisites() {
    echo "Checking prerequisites..."
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Please install it to proceed."
        exit 1
    fi
    echo "AWS CLI is installed. Proceeding with script execution."
}

# Function to create EC2 instances
create_ec2_instances() {
    local instance_count=$1
    echo "Attempting to create $instance_count EC2 instance(s) in region $REGION..."

    # Use a variable for the output to allow for better error checking
    create_output=$(aws ec2 run-instances \
        --image-id "$AMI_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --count "$instance_count" \
        --key-name "$KEY_PAIR_NAME" \
        --tag-specifications "ResourceType=instance,Tags=[{$TAGS}]" \
        --region "$REGION" 2>&1)

    if [ $? -eq 0 ]; then
        echo "EC2 instance(s) created successfully."
        instance_ids=$(echo "$create_output" | grep "InstanceId" | awk -F': ' '{print $2}' | tr -d ',"')
        echo "Created instance IDs: $instance_ids"
        echo "Waiting for instances to enter the running state..."
        aws ec2 wait instance-running --instance-ids $instance_ids --region "$REGION"
        echo "Instances are now in the running state."
    else
        echo "Failed to create EC2 instances."
        echo "Error: $create_output"
        exit 1
    fi
}

# Function to list running EC2 instances with a specific tag
list_ec2_instances() {
    echo "Listing EC2 instances with tag '$TAGS'..."
    aws ec2 describe-instances \
        --filters "Name=tag-key,Values=Project" "Name=tag-value,Values=Moniepoint" \
        --query "Reservations[].Instances[].[InstanceId, State.Name, PublicIpAddress, Tags[?Key=='Project'].Value | [0]]" \
        --output table \
        --region "$REGION"
}

# Function to terminate all EC2 instances with a specific tag
terminate_ec2_instances() {
    echo "Terminating EC2 instances with tag '$TAGS'..."
    instance_ids_to_terminate=$(aws ec2 describe-instances \
        --filters "Name=tag-key,Values=Project" "Name=tag-value,Values=Moniepoint" \
        --query "Reservations[].Instances[].InstanceId" \
        --region "$REGION" \
        --output text)

    if [ -n "$instance_ids_to_terminate" ]; then
        echo "Found instances to terminate: $instance_ids_to_terminate"
        aws ec2 terminate-instances --instance-ids $instance_ids_to_terminate --region "$REGION"
        echo "Termination command sent. Waiting for instances to be terminated..."
        aws ec2 wait instance-terminated --instance-ids $instance_ids_to_terminate --region "$REGION"
        echo "EC2 instances successfully terminated."
    else
        echo "No EC2 instances with tag '$TAGS' found to terminate."
    fi
}