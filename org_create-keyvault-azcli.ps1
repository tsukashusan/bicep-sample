$keyVault = az keyvault list --query '[?name==`sukamsmcjp0528`]' | ConvertFrom-Json

$privateKey = @"
-----BEGIN OPENSSH PRIVATE KEY-----
<private key>
-----END OPENSSH PRIVATE KEY-----

"@

Set-Content -Path .\secretfile.txt -Value ${privateKey}
az keyvault secret set --vault-name ${keyVault}.name --name ${secretName}  --file ".\secretfile.txt"
Remove-Item .\secretfile.txt