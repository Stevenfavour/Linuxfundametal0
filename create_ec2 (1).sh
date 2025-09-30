#!/bin/bash

# A script to create and manage EC2 instances based on user-provided arguments.

# --- Global Variables ---

# Define global variables for instance parameters
INSTANCE_TYPE="t3.micro"
AMI_ID="ami-0fb8efad694980789"
REGION="eu-north-1"
KEY_PAIR_NAME="serverEC2"
TAGS="Key=Project,Value=Moniepoint"

# --- VPC and Subnet Configuration ---
# You need to fill in your specific VPC and subnet IDs here.
VPC_ID="vpc-0c9ed6d4714ae67db"
SUBNET_ID="subnet-030b4030e3f81b7a1"

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
        --region "$REGION" \
        --subnet-id "$SUBNET_ID" 2>&1)

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

create_ec2_instances $1