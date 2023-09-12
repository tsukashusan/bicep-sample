//scope
targetScope = 'resourceGroup'
var randomstring = toLower(replace(uniqueString(subscription().id, resourceGroup().id), '-', ''))
//Storage account for deployment scripts
var location = resourceGroup().location
param ipaddress string
param vmsize string
var vNetIpPrefix  = '192.168.0.0/24'
var defaultSubnetIpPrefix = '192.168.0.0/27'
var bastionSubnetIpPrefix = '192.168.0.32/27'

//Storage account for deployment scripts
module storage 'storage-account.bicep' = {
  name: 'deploymentScriptStorage'
  params: {
    location: location
    ipaddress: ipaddress
  }
}

module vnet 'virtual_network.bicep' = {
  name: 'vnet'
  params:{
    virtualNetworkName: 'vnet01'
    vNetIpPrefix: vNetIpPrefix
    defaultSubnetIpPrefix: defaultSubnetIpPrefix
    location: location
    bastionSubnetIpPrefix: bastionSubnetIpPrefix
  }
}

module windowsServer 'virtual_machine4Windows.bicep' = {
  name: 'selfhostedIR'
  params: {
    location: location
    name: 'selfHosted-${randomstring}'
    nicifname: 'vmnicwin-${randomstring}'
    storageAccountType: 'StandardSSD_LRS'
    subnetId: vnet.outputs.subnetId
    vmSize: vmsize
  }
}


module mysql 'virtual_machine4Linux.bicep' = {
  name: 'mysql'
  params:{
    name: 'mysql80-${randomstring}'
    nicifname: 'vmnicmysql-${randomstring}'
    location: location
    vmSize: vmsize
    subnetId: vnet.outputs.subnetId
    storageAccountType: 'StandardSSD_LRS'
  }
  dependsOn:[
    vnet
  ]
}


module bastion 'bastionhost.bicep' = {
  name: 'bastion'
  params:{
    location: location
    bastionHostName: 'bastionhost'
    virtualNetworkName: vnet.outputs.vnetname
    bastionSubnetIpPrefix: bastionSubnetIpPrefix
    ipaddress: ipaddress
  }
  dependsOn:[
    vnet
  ]
}
