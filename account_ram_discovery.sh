#!/bin/bash
echo $'\n'
echo "RAM - Resources-Shared shared WITH the Account"
echo "-----------------------------------------------------------"
aws ram get-resource-shares --region $1 --resource-owner OTHER-ACCOUNTS --output table

echo $'\n'
echo "RAM - List of Resources Shared WITH the Account"
echo "-----------------------------------------------------------"
aws ram list-resources --region $1 --resource-owner OTHER-ACCOUNTS --output table

echo $'\n'
echo "RAM - 3.4.3	List of Principals sharing resources WITH the account"
echo "----------------------------------------------------------------------"
aws ram list-principals --region $1 --resource-owner OTHER-ACCOUNTS --output table

echo $'\n'
echo "-------------------------ooOOOoo---------------------------"

echo $'\n'
echo "RAM - Resources-Shared shared BY the Account"
echo "-----------------------------------------------------------"
aws ram get-resource-shares --region $1 --resource-owner SELF --output table

echo $'\n'
echo "RAM - List of Resources Shared BY the Account"
echo "-----------------------------------------------------------"
aws ram list-resources --region $1 --resource-owner SELF --output table

echo $'\n'
echo "RAM - 3.4.3	List of Principals sharing resources BY the account"
echo "----------------------------------------------------------------------"
aws ram list-principals --region $1 --resource-owner SELF --output table