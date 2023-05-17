### Example 1: Trigger a restore after initializing a restore request
```powershell
$req = Initialize-AzRecoveryServicesRestoreRequest -DatasourceType AzureVM -RecoveryType "AlternateLocation" -RecoveryPoint $rp -TargetSubscriptionId $subId -TargetResourceGroupName $resourceGroupName -TargetVMName "hiagaRestore22" -StorageAccountId "/subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft.Storage/storageAccounts/hiagasa" -TargetVNetResourceGroup $resourceGroupName -TargetVNetName "hiagarg-vnet" -TargetSubnetName "default" -Region "centraluseuap"

$string = $rp.Id
$pattern = '/recoveryPoints/(?<recoveryPointId>[^/]+)$'
$matches = [regex]::Match($string, $pattern)
$rpId = $matches.Groups["recoveryPointId"].Value

New-AzRecoveryServicesRestoreRequest -ContainerName $containerName -ProtectedItemName $itemName -RecoveryPointId $rpId -ResourceGroupName $resourceGroupName -VaultName $vaultName -Request $req
```

```output

```

This triggers a restore based on the initialized restore request. The restore job can be seen on the portal or can be tracked using its operation id. 

