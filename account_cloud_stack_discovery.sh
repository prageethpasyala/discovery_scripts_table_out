echo $'\n'
echo "Cloud Stack List"
echo "-----------------------------------------------------------"
aws cloudformation list-stacks --region $1 --output table

echo $'\n'
echo "Cloud StackSet List"
echo "-----------------------------------------------------------"
aws cloudformation list-stack-sets --region $1 --output table
