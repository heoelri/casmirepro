@description('The name for the Cassandra cluster to be created.')
param suffix string = 'heoelri-v3'

@description('Region to create the cluster in.')
param location string = 'eastus'

param tags object = {}

@description('Initial password to set on the cluster for the admin account.')
param initialCassandraAdminPassword string = uniqueString(resourceGroup().id)

@description('The name for the Cassandra data center to be created.')
param dcName string = 'dc1'

@description('The number of nodes to create in this cluster.')
param nodeCount int = 3

@description('Deploy data centers using availability zones if available in the region.')
param enableAvailabilityZones bool = false

@description('What virtual machine SKU to deploy the data center on.')
param sku string = 'Standard_E16s_v5'

@description('What disk SKU the Cassandra data storage should be deployed on.')
param diskSku string = 'P30'

@description('Number of data disks to attach to each Cassandra node.')
param diskCapacity int = 4

@description('Type of identity to use.')
param identityType string = 'none'

@description('Client certificate used to authenticate to Cassandra API.')
param clientCertificates array = []

@description('Version of Cassandra used.')
param cassandraVersion string = '3.11'

@description('Extensions for cluster.')
param extensions array = []

@description('The form of AutoReplicate that is being used by this cluster.')
param autoReplicate string = 'None'

@description('The form of ScheduledEventStrategy that is being used by this cluster.')
param scheduledEventStrategy string = 'Ignore'

@description('Cluster Type')
param clusterType string = 'Production'

var networkContributorRoleDefinitionId = '4d97b98b-1d4f-4787-a291-c67834d212e7' // Azure Network Contributor Role Definition Id
var cosmosDbPrincipalId = 'e5007d2c-4b13-4a74-9b6a-605d99f03501' // AppId 'a232010e-820c-4083-83bb-3ace5fc29d0b' (Azure CosmosDB)
var networkContributorRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions',networkContributorRoleDefinitionId)

resource vnet 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: 'vnet-${suffix}'
  location: location
  tags: tags

  properties: {
    // VNet encryption to protect data flows between VMs in the VNet
    encryption: {
      enabled: true
      enforcement: 'AllowUnencrypted'
    }

    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-cassandra'
        properties: {
          defaultOutboundAccess: false
          addressPrefix: '10.10.2.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.EventHub'
            }
            {
              service: 'Microsoft.AzureActiveDirectory'
            }
          ]
        }
      }
    ]
  }
}

resource snet_cassandra 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: 'snet-cassandra'
  parent: vnet
}

resource cosmosNetworkContributorAuthorization 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, resourceGroup().name, networkContributorRoleId, cosmosDbPrincipalId)
  scope: snet_cassandra
  properties: {
    principalId: cosmosDbPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: networkContributorRoleId
  }
}

resource cluster 'Microsoft.DocumentDB/cassandraClusters@2021-03-01-preview' = {
  name: 'casmi-${suffix}'
  location: location
  identity: {
    type: identityType
  }
  properties: {
    initialCassandraAdminPassword: initialCassandraAdminPassword
    delegatedManagementSubnetId: snet_cassandra.id
    clientCertificates: clientCertificates
    cassandraVersion: cassandraVersion
    extensions: extensions
    autoReplicate: autoReplicate
    scheduledEventStrategy: scheduledEventStrategy
    clusterType: clusterType
  }
  dependsOn: [
    cosmosNetworkContributorAuthorization
  ]
}

resource clusterName_dc 'Microsoft.DocumentDB/cassandraClusters/dataCenters@2021-03-01-preview' = {
  parent: cluster
  name: '${dcName}'
  location: location
  properties: {
    dataCenterLocation: location
    delegatedSubnetId: snet_cassandra.id
    nodeCount: nodeCount
    availabilityZone: enableAvailabilityZones
    sku: sku
    diskSku: diskSku
    diskCapacity: diskCapacity
  }
  dependsOn: [
    cosmosNetworkContributorAuthorization
    cluster
  ]
}
