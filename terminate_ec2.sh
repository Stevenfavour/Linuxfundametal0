TAGS="Key=Project,Value=Moniepoint"
REGION="eu-north-1"


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

terminate_ec2_instances