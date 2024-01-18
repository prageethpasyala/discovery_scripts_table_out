# echo $'\n'
# echo "Intance Summary information ------------------------------"
# aws ec2 describe-instances \
# --query "[[.Reservations[].Instances[]|{ state: .State.Name, type: .InstanceType }]|group_by(.state)|.[]|{state: .[0].state, types: [.[].type]|[group_by(.)|.[]|{type: .[0], count: ([.[]]|length)}] }]" \
# --output table \
# --region $1

# echo $'\n'
# echo "-----------------------------------"
# aws ec2 describe-instances \
# --region $1 | jq -r "[.Reservations[].Instances[]|{ state: .State.Name, type: .InstanceType }]|group_by(.)|.[]|{type: .[0].type, state: .[0].state, count: ([.[]]|length) }|[.type, .state, .count]|@csv"

echo $'\n'
echo "-- Instance Description -----------------------------------"
aws ec2 describe-instances \
--output table \
--region $1

echo $'\n'
echo "-- Running Instances    -----------------------------------"
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  \
--filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*'"  \
--output table --region $1

echo $'\n'
echo "-- Running Instances x AZ   -------------------------------"

for az in $(aws ec2 describe-availability-zones --region $1 | jq -r '.AvailabilityZones[].ZoneName')
do 
    aws ec2 describe-instances --filters Name=availability-zone,Values=$az --region $1 
done;

echo $'\n'
echo "-- Instances with Netowrking Details -------------------------------"

aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Type:InstanceType,Status:State.Name,VpcId:VpcId}" \
--filters Name=instance-state-name,Values=running \
--output table \
--region $1


