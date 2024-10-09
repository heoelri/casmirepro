@description('Azure region to deploy resources to')
param location string = resourceGroup().location

@description('Azure resource tags')
param tags object = {}

@description('Enable zone redundancy for the Cassandra cluster')
param zoneRedundancy bool = true

@description('The SKU of the Cassandra cluster nodes')
param cassandraSku string = 'Standard_E16s_v5'

@description('The SKU of the Cassandra cluster disks')
param cassandraDiskSku string = 'P30'

@description('The capacity of the Cassandra cluster disks')
param cassandraDiskCapacity int = 4

@description('The number of Cassandra nodes in the cluster')
param cassandraNodeCount int = 3

param resourceSuffix string

// Variables
var networkContributorRoleDefinitionId = '4d97b98b-1d4f-4787-a291-c67834d212e7' // Azure Network Contributor Role Definition Id
var cosmosDbPrincipalId = 'e5007d2c-4b13-4a74-9b6a-605d99f03501' // AppId 'a232010e-820c-4083-83bb-3ace5fc29d0b' (Azure CosmosDB)
var networkContributorRoleId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  networkContributorRoleDefinitionId
)
var graphCoscasSecretValue = uniqueString(resourceGroup().id)
// END - Variables

resource graphCassandraCluster 'Microsoft.DocumentDB/cassandraClusters@2021-03-01-preview' = {
  name: 'casmi-graph-${resourceSuffix}'
  location: location
  tags: tags

  identity: {
    type: 'None' //'SystemAssigned'
  }
  properties: {
    initialCassandraAdminPassword: graphCoscasSecretValue
    delegatedManagementSubnetId: snet_cassandra.id
    clientCertificates: []
    cassandraVersion: '4.0'
    retryPolicy: {
      maxRetryCount: 5
      maxRetryDurationInSeconds: 180
    }
  }

  dependsOn: [
    cosmosNetworkContributorAuthorization
  ]
}

resource graphCassandraClusterDataCenter 'Microsoft.DocumentDB/cassandraClusters/datacenters@2021-03-01-preview' = {
  parent: graphCassandraCluster
  name: 'datacenter-1'
  properties: {
    dataCenterLocation: location
    delegatedSubnetId: snet_cassandra.id
    nodeCount: cassandraNodeCount
    availabilityZone: zoneRedundancy
    sku: cassandraSku
    diskSku: cassandraDiskSku
    diskCapacity: cassandraDiskCapacity
    retryPolicy: {
      maxRetryCount: 5
      maxRetryDurationInSeconds: 180
    }
  }
  dependsOn: [
    graphCassandraCluster // mandatory dependency
  ]
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

resource snet_cassandra 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: 'snet-cassandra'
  parent: vnet
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-06-01' = {
  name: 'vnet-${resourceSuffix}'
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
          networkSecurityGroup: {
            id: nsgCassandra.id
          }
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

// Cassandra network security rules
// https://learn.microsoft.com/en-us/azure/managed-instance-apache-cassandra/network-rules
resource nsgCassandra 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: 'nsg-cassandra-${resourceSuffix}'
  location: location
  tags: tags
}

var cassandraNsgDestinations = [
  'Storage'
  'EventHub'
  'AzureKeyVault'
  'AzureMonitor'
  'AzureActiveDirectory'
  'AzureResourceManager'
  'GuestAndHybridManagement'
  'ApiManagement'
  'AzureFrontDoor.Firstparty'
]

resource nsgrCassandraOutbound443 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = [
  for (destination, index) in cassandraNsgDestinations: {
    parent: nsgCassandra
    name: 'nsgr-coscas-outbound-443-${destination}'
    properties: {
      priority: 111 + index
      direction: 'Outbound'
      access: 'Allow'
      protocol: 'Tcp'
      sourcePortRange: '*'
      sourceAddressPrefix: '*'
      destinationPortRanges: [
        '443'
      ]
      destinationAddressPrefix: destination
    }
  }
]

// For the following address prefixes no service tag exists.
// https://learn.microsoft.com/en-us/azure/managed-instance-apache-cassandra/network-rules
resource nsgrCassandraOutboundMisc 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  parent: nsgCassandra
  name: 'nsgr-coscas-outbound-misc'
  properties: {
    priority: 110
    direction: 'Outbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    sourceAddressPrefix: '*'
    destinationPortRanges: [
      '443'
    ]
    destinationAddressPrefixes: [
      '104.40.0.0/13'
      '13.104.0.0/14'
      '40.64.0.0/10'
    ]
  }
}
