#!/bin/bash

region_scripts() {
    REGION=$1

    echo "Gathering account number"
    echo $'\n'
    ACCOUNT=$(aws sts get-caller-identity --query "Account" | sed 's/"//g')
    echo "ACCOUNT:" $ACCOUNT
    echo "REGION:" $REGION

    echo $'\n'
    echo "STEP 1 of 9"
    echo "Gathering network information, it make take several minutes, be patient..."
    file1=${ACCOUNT}_${REGION}_network_info.txt
    echo $file1
    ./account_network_discovery.sh $REGION | tee $file1

    echo $'\n'
    echo "STEP 2 of 9"
    echo "Gathering Lambda Function information, it make take several minutes, be patient..."
    file2=${ACCOUNT}_${REGION}_lambda_info.txt
    echo $file2
    ./account_lambda_discovery.sh $REGION | tee $file2 

    echo $'\n'
    echo "STEP 3 of 9"
    echo "Gathering Services information running on the account"
    file3=${ACCOUNT}_${REGION}_servicesUsed_info.txt
    echo $file3
    ./account_services_discovery.sh $REGION | tee $file3 

    echo $'\n'
    echo "STEP 4 of 9"
    echo "Gathering Instance information, it make take several minutes, be patient..."
    file4=${ACCOUNT}_${REGION}_Instance_info.txt
    echo $file4
    ./account_instance_discovery.sh $REGION | tee $file4 

    echo $'\n'
    echo "STEP 5 of 9"
    echo "Gathering KEYs information"
    file5=${ACCOUNT}_${REGION}_Key_info.txt
    echo $file5
    aws ec2 describe-key-pairs --region ${REGION} | tee $file5 

    echo $'\n'
    echo "STEP 6 of 9"
    echo "Gathering Instance information, it make take several minutes, be patient..."
    file6=${ACCOUNT}_${REGION}_Instance_info.txt
    echo $file6
    ./account_instance_security_discovery.sh $REGION | tee $file6 

    echo $'\n'
    echo "STEP 7 of 9"
    echo "Gathering Cloud Stack & StackSets information"
    file7=${ACCOUNT}_${REGION}_cloudStack_info.txt
    echo $file7
    ./account_cloud_stack_discovery.sh $REGION | tee $file7 

    echo $'\n'
    echo "STEP 8 of 9"
    echo "Gathering Resource Sharing information"
    file8=${ACCOUNT}_${REGION}_RAM_info.txt
    echo $file8
    ./account_ram_discovery.sh $REGION | tee $file8 

    echo $'\n'
    echo "STEP 9 of 9"
    echo "Generating Credentials Report"
    file9=${ACCOUNT}_${REGION}_credentials_report.txt
    echo $file9
    ./account_credentials_report.sh $REGION $file9 
}


regions=$(<regions.txt)
echo $regions

for i in ${regions//,/ }
do
  echo "----Region($i)----"
  echo $'\n'
  region_scripts $i
done