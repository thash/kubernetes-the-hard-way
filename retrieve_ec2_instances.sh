#!/bin/bash

# NOTE: setting AWS_REGION environment variable allows you to query regions in which you have resources.

VPC_ID=$(aws cloudformation describe-stacks \
  --stack-name hard-k8s-network \
  --query 'Stacks[0].Outputs[?ExportName==`hard-k8s-vpc`].OutputValue' --output text)

aws ec2 describe-instances \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value | [0],InstanceId,Placement.AvailabilityZone,PrivateIpAddress,PublicIpAddress,State.Name]' \
  --output text | sort
