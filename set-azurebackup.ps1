#Get-AzResourceProvider -ListAvailable
$TENANT_ID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$SUBSCRIPTOIN_GUID = "dc5d3c89-36dd-4a3c-b09b-e6ee41f6d5b5"
$location = "japanwest"

$resourceGroupName = "<resourceGroupName>"
$location = "<location>"
$recoveryServiceVaultName = "<recoveryServiceVaultName>"

Connect-AzAccount -Tenant ${TENANT_ID} -Subscription ${SUBSCRIPTOIN_GUID}

New-AzResourceGroup -Name ${resourceGroupName} -Location ${location} -Verbose

Get-AzResourceProvider `
   -ProviderNamespace Microsoft.RecoveryServices `
   -Location $location
Get-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
Register-AzResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"

New-AzRecoveryServicesVault -Name ${recoveryServiceVaultName} -ResourceGroupName $resourceGroupName -Location $location
