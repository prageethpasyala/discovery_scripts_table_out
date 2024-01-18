echo $'\n'
echo "Intance Security information (All Instances)"
echo "-----------------------------------------------------------"
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name'].Value|[0],Status:State.Name,VpcId:VpcId,InstanceID:InstanceId,Groups:join(',',NetworkInterfaces[].Groups[].GroupId),IamInstanceProfile:IamInstanceProfile.Arn}" \
--output table --region $1 

echo $'\n'
echo "Intance Security information (Running STATE)"
echo "-----------------------------------------------------------"
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name'].Value|[0],Status:State.Name,VpcId:VpcId,InstanceID:InstanceId,Groups:join(',',NetworkInterfaces[].Groups[].GroupId),IamInstanceProfile:IamInstanceProfile.Arn}" \
--filters "Name=instance-state-name,Values=running" \
--output table --region $1 

echo $'\n'
echo "Intance Security information (Stopped STATE)"
echo "-----------------------------------------------------------"
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name'].Value|[0],Status:State.Name,VpcId:VpcId,InstanceID:InstanceId,Groups:join(',',NetworkInterfaces[].Groups[].GroupId),IamInstanceProfile:IamInstanceProfile.Arn}" \
--filters "Name=instance-state-name,Values=stopped" \
--output table --region $1 

echo $'\n'
echo " Account Policies"
echo "-----------------------------------------------------------"
aws iam list-policies --scope Local --only-attached --query "Policies[].Arn" --output table --region $1 

echo $'\n'
echo " Account Roles "
echo "-----------------------------------------------------------"
for role in $(aws iam list-roles --region $1 | jq -r '.Roles[].RoleName')
do 
    echo $role; 
done

echo $'\n'
echo " Role Policies x Account Role V1"
echo "-----------------------------------------------------------"
for role in $(aws iam list-roles --region $1 | jq -r '.Roles[].RoleName')
do 
    echo $role; 
    aws iam list-role-policies --role-name $role --region $1 | jq
    echo "-------------"
    echo $'\n'
done

# Get list of IAM roles
roles=$(aws iam list-roles --region $1 --query "Roles[*].[RoleName,Arn]" --output text)
# Output headers to CSV file
echo $'\n'
echo " Role Policies x Account Role V2"
echo "-----------------------------------------------------------"
echo "RoleName,RoleArn,AttachedPolicies" 
# Loop through each IAM role and append details to CSV file
while read -r role; do
    role_name=$(echo "$role" | cut -f1)
    role_arn=$(echo "$role" | cut -f2)
    
    # Get list of attached policies for each role
    attached_policies=$(aws iam list-attached-role-policies --role-name $role_name --region $AWS_REGION --query "AttachedPolicies[*].PolicyName" --output text)
    
    echo "$role_name,$role_arn,\"$attached_policies\"" | tr '\t' ','
done <<< "$roles"



