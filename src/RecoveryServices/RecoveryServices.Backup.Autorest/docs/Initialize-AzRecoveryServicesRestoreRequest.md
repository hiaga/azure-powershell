---
external help file:
Module Name: Az.RecoveryServices
online version: https://docs.microsoft.com/powershell/module/az.recoveryservices/initialize-azrecoveryservicesrestorerequest
schema: 2.0.0
---

# Initialize-AzRecoveryServicesRestoreRequest

## SYNOPSIS
Initializes Restore Request object for triggering restore on a protected backup instance.

## SYNTAX

```
Initialize-AzRecoveryServicesRestoreRequest [-DataSourceLogicalName <String>] [-DataSourcePath <String>]
 [-DatasourceType <DatasourceTypes>] [-DataTargetPath <String>] [-DiskEncryptionSetId <String>]
 [-LogSourceLogicalName <String>] [-LogSourcePath <String>] [-LogTargetPath <String>]
 [-NonRecoverable <Boolean>] [-OverwriteOption <String>] [-RecoveryMode <String>]
 [-RecoveryPoint <IRecoveryPointResource>] [-RecoveryType <String>] [-Region <String>]
 [-RehydrateDuration <String>] [-RehydratePriority <String>] [-RestoreDiskList <String[]>]
 [-RestoreOnlyOSDisk] [-StorageAccountId <String>] [-TargetContainerId <String>]
 [-TargetDatabaseName <String>] [-TargetDirectory <String>] [-TargetResourceGroupName <String>]
 [-TargetSubnetName <String>] [-TargetSubscriptionId <String>] [-TargetVMName <String>]
 [-TargetVNetName <String>] [-TargetVNetResourceGroup <String>] [-TargetZoneNumber <Int32>]
 [-UserAssignedIdentityId <String>] [-UseSystemAssignedIdentity] [<CommonParameters>]
```

## DESCRIPTION
Initializes Restore Request object for triggering restore on a protected backup instance.

## EXAMPLES

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

Initializes a restore request object for AzureVM alternate location restore.
This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

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

Initializes a restore request object for SAPHANA original location restore.
This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

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

Initializes a restore request object for SAPHANA restore as file restore.
This request can be passed to New-AzRecoveryServicesRestoreRequest to trigger the restore operation.

### Example 4: Initializing SAPHANA point-in-time restore request 
```powershell

```

{{ Add description here }}

### Example 5: Initializing AzureVM restore-with-rehydrate request 
```powershell

```

{{ Add description here }}

## PARAMETERS

### -DataSourceLogicalName
Specifies the DataSourceLogicalName.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSourcePath
Specifies the DataSourcePath.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceType
Specifies the DatasourceType

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataTargetPath
Specifies the DataTargetPath.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiskEncryptionSetId
Specifies the DiskEncryptionSetId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogSourceLogicalName
Specifies the LogSourceLogicalName.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogSourcePath
Specifies the LogSourcePath.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogTargetPath
Specifies the LogTargetPath.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NonRecoverable
Specifies whether we need to set NonRecoverable option.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverwriteOption
Specifies the OverwriteOption in case of conflicting names.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryMode
Specifies the RecoveryMode.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryPoint
Specifies the recovery point.
To construct, see NOTES section for RECOVERYPOINT properties and create a hash table.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRecoveryPointResource
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryType
Specifies the RecoveryType.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Region
Specifies the target region.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RehydrateDuration
Specifies the rehydrate duration.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RehydratePriority
Specifies the rehydrate priority.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestoreDiskList
Specifies the list of restore disks.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestoreOnlyOSDisk
Specifies whether we need to restore only the OS disk.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorageAccountId
Specifies the target StorageAccountId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetContainerId
Specifies the ContainerId in which target VM is created.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDatabaseName
Specifies the target DB name which is created.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetDirectory
Specifies the target directory in which restore file is created.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetResourceGroupName
Specifies the target resourceGroupName.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetSubnetName
Specifies the target subnet name.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetSubscriptionId
Specifies the target subscriptionId.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetVMName
Specifies the name of target VM to which we restore.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetVNetName
Specifies the name of the target VNet.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetVNetResourceGroup
Specifies the resourceGroupName of the target VNet.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetZoneNumber
Specifies the target zone number.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserAssignedIdentityId
Specifies user assigned identity.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSystemAssignedIdentity
Specifies whether we need to use the system assigned identity.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.RestoreRequest

## NOTES

ALIASES

COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.


`RECOVERYPOINT <IRecoveryPointResource>`: Specifies the recovery point.
  - `[ETag <String>]`: Optional ETag.
  - `[Location <String>]`: Resource location.
  - `[Tag <IResourceTags>]`: Resource tags.
    - `[(Any) <String>]`: This indicates any property can be added to this object.
  - `[ObjectType <String>]`: This property will be used as the discriminator for deciding the specific types in the polymorphic chain of types.

## RELATED LINKS

