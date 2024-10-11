# based on https://learn.microsoft.com/en-us/azure/managed-instance-apache-cassandra/create-cluster-cli
resourceGroupName='heoelri-cli-test-1'
clusterName='casmi-heoelri'
location='eastus2'
initialCassandraAdminPassword='myPassword'
cassandraVersion='3.11' # set to 4.0 for a Cassandra 4.0 cluster
vnetName='vnet-heoelri'
subscriptionId='bbea1c68-4c8d-4a1d-abf4-4e89ad6d4466'
subnetName='casmi'

az account set -s $subscriptionId
az group create -n $resourceGroupName -l $location
az network vnet create -n $vnetName -l $location -g $resourceGroupName --subnet-name $subnetName

az role assignment create --assignee a232010e-820c-4083-83bb-3ace5fc29d0b --role 4d97b98b-1d4f-4787-a291-c67834d212e7 --scope /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Network/virtualNetworks/$vnetName

delegatedManagementSubnetId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName"

az managed-cassandra cluster create \
  --cluster-name $clusterName \
  --resource-group $resourceGroupName \
  --location $location \
  --delegated-management-subnet-id $delegatedManagementSubnetId \
  --initial-cassandra-admin-password $initialCassandraAdminPassword \
  --cassandra-version $cassandraVersion \
  --debug