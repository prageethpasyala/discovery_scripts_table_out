# #!/bin/bash
# echo $'\n'
# echo "Services x Account"
# echo "-----------------------------------------------------------"
# aws ce get-cost-and-usage --time-period Start=$(date -v-1m '+%Y-%m-01'),End=$(date -v-1S '+%Y-%m-01') \
# --granularity MONTHLY --metrics UsageQuantity \
# --group-by Type=DIMENSION,Key=SERVICE \
# --region $1 | jq '.ResultsByTime[].Groups[] | select(.Metrics.UsageQuantity.Amount > 0) | .Keys[0]'


#!/bin/bash
echo $'\n'
echo "Services x Account"
echo "-----------------------------------------------------------"
aws ce get-cost-and-usage --time-period Start=$(date -d "$(date '+%Y-%m-01' -d '1 month ago')" '+%Y-%m-%d'),End=$(date -d "$Start +1 month -1 day" '+%Y-%m-%d') \
--granularity MONTHLY --metrics UsageQuantity \
--group-by Type=DIMENSION,Key=SERVICE \
# --region $1 | jq '.ResultsByTime[].Groups[] | select(.Metrics.UsageQuantity.Amount > 0) | .Keys[0]'
--region $1 --query 'ResultsByTime[].Groups[?Metrics.UsageQuantity.Amount > `0`].Keys[0]' --output table