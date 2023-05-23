### Example 1: Get all backup policies in a recovery services vault
```powershell
$pol = Get-AzRecoveryServicesBackupProtectionPolicy -ResourceGroupName "myresourcegroup" -VaultName "myvault"
$pol | fl 
```                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 


```output
BackupManagementType          : AzureWorkload
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/wao
Location                      :
Name                          : wao
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureVMWorkload
                                ProtectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies

BackupManagementType          : AzureWorkload
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/HourlyLogBackup
Location                      :
Name                          : HourlyLogBackup
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureVMWorkload
                                ProtectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies

BackupManagementType          : AzureIaasVM
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/DefaultPolicy
Location                      :
Name                          : DefaultPolicy
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureIaaSvmProt
                                ectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies

BackupManagementType          : AzureIaasVM
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/delete-test
Location                      :
Name                          : delete-test
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureIaaSvmProt
                                ectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies

BackupManagementType          : AzureWorkload
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/anssingh-testPolicy
Location                      :
Name                          : anssingh-testPolicy
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureVMWorkload
                                ProtectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies

BackupManagementType          : AzureIaasVM
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-2203
                                51dcce8c/resourceGroups/anssingh-rg/provide
                                rs/Microsoft.RecoveryServices/vaults/anssin
                                gh-vault/backupPolicies/EnhancedPolicy
Location                      :
Name                          : EnhancedPolicy
Property                      : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.AzureIaaSvmProt
                                ectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.Recovery
                                Services.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPol
                                icies
```


Gets all the backup policies in the specified vault in the specified resource group.

### Example 2: Get info for a specific backup policy
```powershell
$pol = Get-AzRecoveryServicesBackupProtectionPolicy -ResourceGroupName "myresourcegroup" -VaultName "myvault" -Name "DefaultPolicy"
$pol | fl 
```

```output
BackupManagementType          : AzureWorkload
ETag                          :
Id                            : /subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/anssingh-rg/providers/Microsoft.Recove
                                ryServices/vaults/anssingh-vault/backupPolicies/anssingh-testPolicy
Location                      :
Name                          : anssingh-testPolicy
Property                      : Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureVMWorkloadProtectionPolicy
ProtectedItemsCount           : 0
ResourceGuardOperationRequest :
Tag                           : Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.ResourceTags
Type                          : Microsoft.RecoveryServices/vaults/backupPolicies
```

Gets info for a specific backup policy by its name in the specified vault in the specified resource group.
