param location string
param bastionHostName string
param virtualNetworkName string
param bastionSubnetIpPrefix string
param ipaddress string

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: '${bastionHostName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource subNet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworkName}/AzureBastionSubnet'
  properties: {
    addressPrefix: bastionSubnetIpPrefix
    networkSecurityGroup:{
      id:securityGroup1.id
    }
  }
}

resource securityGroup1 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'abc'
  location:location
  properties:{
    securityRules:[
      {
        name: 'rule1'
        properties:{
          protocol:'Tcp'
          direction:'Inbound'
          access:'Allow'
          sourceAddressPrefixes:[
            ipaddress
          ]
          destinationPortRanges:[
            '443'
          ]
          priority: 100
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
        }
        
      }
      {
        name: 'rule1'
        properties:{
          protocol:'Tcp'
          direction:'Inbound'
          access:'Allow'
          sourceAddressPrefixes:[
            ipaddress
          ]
          destinationPortRanges:[
            '443'
          ]
          priority: 100
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2020-11-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: subNet.id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}
