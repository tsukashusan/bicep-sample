param name string
param nicifname string
param location string
param vmSize string
param subnetId string
param storageAccountType string


resource vmnic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: nicifname
  location: location
  properties:{
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties:{
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion:'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: true
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile:{
      vmSize: vmSize
    }
    networkProfile:{
      networkInterfaces:[
        {
          id: vmnic.id
        }
      ]
    }
    storageProfile:{
      imageReference:{
        id: '/subscriptions/dc5d3c89-36dd-4a3c-b09b-e6ee41f6d5b5/resourceGroups/shared-image/providers/Microsoft.Compute/galleries/mysql4Onprem/images/MySQL8.0/versions/1.0.0'
      }
      osDisk:{
        createOption:'FromImage'
        managedDisk:{
          storageAccountType: storageAccountType
        }
      }
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled: true
      }
    }
  }
}
