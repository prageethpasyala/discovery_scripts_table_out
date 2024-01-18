#!/bin/bash
##
## This script is doing the following tasks
## 1. GET the List of ALL Lambda Functions ARNs on the Account
##    aws lambda list-functions --query "Functions[*].FunctionArn" --output text
##
## 2. For each lambda, get the configuration and extract the RoleName
##    aws lambda get-function-configuration --function-name $f --query "Role" --output text | cut -d "/" -f 2
##
## 3. List the attached policies for each role
##    aws iam list-attached-role-policies --role-name $role --query "AttachedPolicies[*].PolicyArn" --output text  
##
## 4. For each NO AWS Managed policy, retrieve the IAM Policy Details
##    aws iam get-policy --policy-arn $p --output json
##
echo $'\n'
for f in $(aws lambda list-functions --query 'Functions[*].FunctionArn' --region $1 --output text)
do 
    echo "-----------------------------------------------------------"
    role=$(aws lambda get-function-configuration --function-name $f --query "Role" --output text --region $1 | cut -d "/" -f 2)
    echo "Function: $f"
    echo "Role: $role"
    policies=$(aws iam list-attached-role-policies --role-name $role --query "AttachedPolicies[*].PolicyArn" --output text --region $1)
    echo $policies
    for p in $policies
    do
      aux=$(echo $p | cut -d "/" -f 2)
      echo "Policy: $aux"
      echo "PolicyARN: $p"
      if [ ${aux:0:3} != "AWS" ]
      then 
        echo "-->USER MANAGED"
        policy=$(aws iam get-policy --policy-arn $p --output json --region $1)
        echo $policy
        echo "---"
      fi
    done 
    echo $'\n'
done

