$keyVaultName = "<keyVaultName>" #keyvaultName from azuredeploy.parameters.dev.json
$keyVault = Get-AzKeyVault -VaultName ${keyVaultName}

$secretName = "sshkey4vm"

$privateKey = @"
-----BEGIN OPENSSH PRIVATE KEY-----
<privateKey>
-----END OPENSSH PRIVATE KEY-----
"@ 

$secretvalue = ConvertTo-SecureString ${privateKey} -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName ${keyVault}.VaultName -Name ${secretName} -SecretValue ${secretvalue}
