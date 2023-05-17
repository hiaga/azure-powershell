### Example 1: Initializing AzureVM alternate location restore request 
```powershell
$vaultName = "hiagaVault"

$resourceGroupName = "hiagarg"

$subId = "38304e13-357e-405e-9e9a-220351dcce8c"

$container = Get-AzRecoveryServicesBackupProtectionContainer -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId -Filter "backupManagementType eq 'AzureIaasVM'"

$item = Get-AzRecoveryServicesBackupProtectedItem -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId

$rp = Get-AzRecoveryServicesRecoveryPoint -ContainerName $container[0].Name -FabricName "Azure" -ProtectedItemName $item[0].Name -ResourceGroupName $resourceGroupName -VaultName $vaultName

$req = Initialize-AzRecoveryServicesRestoreRequest -DatasourceType "AzureVM" -RecoveryType "AlternateLocation" -RecoveryPoint $rp[0] -TargetSubscriptionId $subId -TargetResourceGroupName $resourceGroupName -TargetVMName "hiagaRestore22" -StorageAccountId "/subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft.Storage/storageAccounts/hiagasa" -TargetVNetResourceGroup $resourceGroupName -TargetVNetName "hiagarg-vnet" -TargetSubnetName "default" -Region "centraluseuap" 

$req | fl
```

```output
AffinityGroup                                               :
CreateNewCloudService                                       : False
DiskEncryptionSetId                                         :
EncryptionDetailEncryptionEnabled                           :
EncryptionDetailKekUrl                                      :
EncryptionDetailKekVaultId                                  :
EncryptionDetailSecretKeyUrl                                :
EncryptionDetailSecretKeyVaultId                            :
ExtendedLocationName                                        :
ExtendedLocationType                                        :
IdentityBasedRestoreDetailObjectType                        :
IdentityBasedRestoreDetailTargetStorageAccountId            :
IdentityInfoIsSystemAssignedIdentity                        :
IdentityInfoManagedIdentityResourceId                       :
ObjectType                                                  : IaasVMRestoreRequest
OriginalStorageAccountOption                                : False
RecoveryPointId                                             : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .RecoveryServices/vaults/hiagaVault/backupFabrics/Azure/protectionContainers/IaasVMContainer;i
                                                              aasvmcontainerv2;hiagarg;hiaganewvm1/protectedItems/VM;iaasvmcontainerv2;hiagarg;hiaganewvm1/r
                                                              ecoveryPoints/174354385722076
RecoveryType                                                : AlternateLocation
Region                                                      : centraluseuap
RestoreDiskLunList                                          :
RestoreWithManagedDisk                                      : False
SecuredVMDetailSecuredVmosdiskEncryptionSetId               :
SourceResourceId                                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .Compute/virtualMachines/hiagaNewVm1
StorageAccountId                                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .Storage/storageAccounts/hiagasa
SubnetId                                                    : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .Network/virtualNetworks/hiagarg-vnet/subnets/default
TargetDiskNetworkAccessSettingTargetDiskAccessId            :
TargetDiskNetworkAccessSettingTargetDiskNetworkAccessOption :
TargetDomainNameId                                          :
TargetResourceGroupId                                       : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg
TargetVirtualMachineId                                      : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .Compute/virtualMachines/hiagaRestore22
VirtualNetworkId                                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft
                                                              .Network/virtualNetworks/hiagarg-vnet
Zone                                                        :
```

Initializes a restore request object for AzureVM alternate location restore. This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

### Example 2: Initializing SAPHANA original location restore request 
```powershell
$vaultName = "saphana-eus-pstest-vault"

$resourceGroupName = "saphana-eus-pstest-rg"

$subId = "38304e13-357e-405e-9e9a-220351dcce8c"

$container = Get-AzRecoveryServicesBackupProtectionContainer -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId -Filter "backupManagementType eq 'AzureWorkload'"

$item = Get-AzRecoveryServicesBackupProtectedItem -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId

$rp = Get-AzRecoveryServicesRecoveryPoint -ContainerName $container[0].Name -FabricName "Azure" -ProtectedItemName $item[0].Name -ResourceGroupName $resourceGroupName -VaultName $vaultName

$req = Initialize-AzRecoveryServicesRestoreRequest -DatasourceType "SAPHANA" -RecoveryType "OriginalLocation"  

$req | fl
```

```output
ObjectType                              : AzureWorkloadSAPHanaRestoreRequest
PropertyBag                             : Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadRestoreRequestPropertyBag
RecoveryMode                            :
RecoveryType                            : OriginalLocation
SourceResourceId                        :
TargetInfo                              : Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.TargetRestoreInfo
TargetInfoContainerId                   :
TargetInfoDatabaseName                  :
TargetInfoOverwriteOption               :
TargetInfoTargetDirectoryForFileRestore :
TargetVirtualMachineId                  :
```

Initializes a restore request object for SAPHANA original location restore. This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

### Example 3: Initializing SAPHANA restore as file restore request 
```powershell
$vaultName = "saphana-eus-pstest-vault"

$resourceGroupName = "saphana-eus-pstest-rg"

$subId = "38304e13-357e-405e-9e9a-220351dcce8c"

$container = Get-AzRecoveryServicesBackupProtectionContainer -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId -Filter "backupManagementType eq 'AzureWorkload'"

$item = Get-AzRecoveryServicesBackupProtectedItem -ResourceGroupName $resourceGroupName -VaultName $vaultName -SubscriptionId $subId

$rp = Get-AzRecoveryServicesRecoveryPoint -ContainerName $container[0].Name -FabricName "Azure" -ProtectedItemName $item[0].Name -ResourceGroupName $resourceGroupName -VaultName $vaultName

$req = Initialize-AzRecoveryServicesRestoreRequest -DatasourceType "AzureVM" -RecoveryType "AlternateLocation" -RecoveryMode "FileRecovery" -RecoveryPoint $rp[0] -TargetSubscriptionId $subId -TargetResourceGroupName $resourceGroupName -TargetVMName "hiagaRestore25" -TargetContainerId $container[0].Id -TargetDirectory "/tmp"  

$req | fl
```

```output
AffinityGroup                                               :
CreateNewCloudService                                       : False
DiskEncryptionSetId                                         :
EncryptionDetailEncryptionEnabled                           :
EncryptionDetailKekUrl                                      :
EncryptionDetailKekVaultId                                  :
EncryptionDetailSecretKeyUrl                                :
EncryptionDetailSecretKeyVaultId                            :
ExtendedLocationName                                        :
ExtendedLocationType                                        :
IdentityBasedRestoreDetailObjectType                        :
IdentityBasedRestoreDetailTargetStorageAccountId            :
IdentityInfoIsSystemAssignedIdentity                        :
IdentityInfoManagedIdentityResourceId                       :
ObjectType                                                  : IaasVMRestoreRequest
OriginalStorageAccountOption                                : False
RecoveryPointId                                             : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/saphana-eus-pstest-rg/provi
                                                              ders/Microsoft.RecoveryServices/vaults/saphana-eus-pstest-vault/backupFabrics/Azure/protection
                                                              Containers/VMAppContainer;compute;saphana-eus-pstest-rg;saphana-eus-pstest-vm/protectedItems/S
                                                              APHanaDatabase;arv;arv/recoveryPoints/34395179270310
RecoveryType                                                : AlternateLocation
Region                                                      :
RestoreDiskLunList                                          :
RestoreWithManagedDisk                                      : False
SecuredVMDetailSecuredVmosdiskEncryptionSetId               :
SourceResourceId                                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/saphana-eus-pstest-rg/provi
                                                              ders/Microsoft.Compute/virtualMachines/saphana-eus-pstest-vm
StorageAccountId                                            :
SubnetId                                                    : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups//providers/Microsoft.Networ
                                                              k/virtualNetworks//subnets/
TargetDiskNetworkAccessSettingTargetDiskAccessId            :
TargetDiskNetworkAccessSettingTargetDiskNetworkAccessOption :
TargetDomainNameId                                          :
TargetResourceGroupId                                       : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/saphana-eus-pstest-rg
TargetVirtualMachineId                                      : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/saphana-eus-pstest-rg/provi
                                                              ders/Microsoft.Compute/virtualMachines/hiagaRestore25
VirtualNetworkId                                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups//providers/Microsoft.Networ
                                                              k/virtualNetworks/
Zone                                                        :
```

Initializes a restore request object for SAPHANA restore as file restore. This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

### Example 4: Initializing SAPHANA point-in-time restore request 
```powershell
```

```output
```

{{ Add description here }}

### Example 5: Initializing AzureVM restore-with-rehydrate request 
```powershell
```

```output
```

{{ Add description here }}
