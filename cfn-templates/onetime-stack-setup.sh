#!/bin/bash
region="eu-west-2"

VPC_TEMPLATE=file://vpc.cfn.yml
aws cloudformation update-stack --stack-name=vpc-resources-dev \
--template-body=$VPC_TEMPLATE \
#--parameters ParameterKey=CloudWatchLogGroup,ParameterValue=dev \
#ParameterKey=CloudWatchLogRetentionInDays,ParameterValue=180 \
--parameters ParameterKey=EcrRepositoryName,ParameterValue=dev-repository \
ParameterKey=Environment,ParameterValue=dev \
ParameterKey=ECSClusterName,ParameterValue=dev-cluster
#$ParameterKey=AllowedCidr,ParameterValue=0.0.0.0/0 \
#--capabilities CAPABILITY_NAMED_IAM