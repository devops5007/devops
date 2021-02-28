#!/bin/bash
set -e
REGION="eu-west-2"
  #update the parameters file with current built docker image version.
echo 'checking if stack is ready to deploy::::'
export status=$(aws cloudformation describe-stacks --stack-name=$CFN_STACK --region ${REGION} --query Stacks[].StackStatus --output text)
    while [[ $status == *PROGRESS ]]; do
    sleep 10
export status=$(aws cloudformation describe-stacks --stack-name=$CFN_STACK --region ${REGION} --query Stacks[].StackStatus --output text)
    done
aws cloudformation update-stack --stack-name $CFN_STACK --use-previous-template --region ${REGION} --capabilities CAPABILITY_NAMED_IAM  --parameters file://parameters.json
       [[ $status == "*COMPLETE" ]] &&
       sleep 15
       echo 'watch deployment status::::'
aws cloudformation describe-stack-events --region ${REGION} --stack-name $CFN_STACK  --max-items 6 | jq -r  ".StackEvents[]| \" \(.Timestamp | sub(\"\\\\.[0-9]+Z$\"; \"Z\") | fromdate | strftime(\"%H:%M:%S\") )  \(.LogicalResourceId) \(.ResourceType) \(.ResourceStatus)\"" | column -t
export status=$(aws cloudformation describe-stacks --stack-name=$CFN_STACK --region ${REGION} --query Stacks[].StackStatus --output text)
    while [[ $status != *COMPLETE && $status != *FAILED ]]; do
    sleep 10
export status=$(aws cloudformation describe-stacks --stack-name=$CFN_STACK --region ${REGION} --query Stacks[].StackStatus --output text)
    done
echo $status
      [[ $status == "UPDATE_COMPLETE" || $status == "CREATE_COMPLETE" ]]
