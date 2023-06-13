@description('Location for all resources.')
param location string = resourceGroup().location

var abbrev = 'TEST'
var vnetPrefix = '172.19.255.0/24'
var gatewaySubnetName = 'GatewaySubnet'
var srvSubnetName = '${abbrev}-SRV-SUB'
var gatewaySubnetPrefix = '172.19.255.128/27'
var srvSubnetPrefix = '172.19.255.0/25'
var virtualNetworkName = '${abbrev}-VNET-PROD'
var networkSecurityGroupName = 'default-NSG'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: gatewaySubnetName
        properties: {
          addressPrefix: gatewaySubnetPrefix
          /*networkSecurityGroup: {
            id: networkSecurityGroup.id
          }*/
        }
      }
      { name: srvSubnetName
        properties: {
          addressPrefix: srvSubnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}
