---
external help file:
Module Name: Az.RecoveryServices
online version: https://docs.microsoft.com/powershell/module/az.recoveryservices/new-azrecoveryservicesrestorerequest
schema: 2.0.0
---

# New-AzRecoveryServicesRestoreRequest

## SYNOPSIS
Triggers restore for the backup item to the specified recovery point.

## SYNTAX

```
New-AzRecoveryServicesRestoreRequest -ProtectedItemName <String> -RecoveryPointId <String>
 -Request <IRestoreRequest> -ResourceGroupName <String> -VaultName <String> [-ContainerName <String>]
 [-DefaultProfile <PSObject>] [-Confirm] [-WhatIf] [<CommonParameters>]
```

## DESCRIPTION
Triggers restore for the backup item to the specified recovery point.

## EXAMPLES

### Example 1: Trigger a restore after initializing a restore request
```powershell
$req = Initialize-AzRecoveryServicesRestoreRequest -DatasourceType AzureVM -RecoveryType "AlternateLocation" -RecoveryPoint $rp -TargetSubscriptionId $subId -TargetResourceGroupName $resourceGroupName -TargetVMName "hiagaRestore22" -StorageAccountId "/subscriptions/38304e13-357e-405e-9e9a-220351dcce8c/resourceGroups/hiagarg/providers/Microsoft.Storage/storageAccounts/hiagasa" -TargetVNetResourceGroup $resourceGroupName -TargetVNetName "hiagarg-vnet" -TargetSubnetName "default" -Region "centraluseuap"

$string = $rp.Id
$pattern = '/recoveryPoints/(?<recoveryPointId>[^/]+)$'
$matches = [regex]::Match($string, $pattern)
$rpId = $matches.Groups["recoveryPointId"].Value

New-AzRecoveryServicesRestoreRequest -ContainerName $containerName -ProtectedItemName $itemName -RecoveryPointId $rpId -ResourceGroupName $resourceGroupName -VaultName $vaultName -Request $req
```

This triggers a restore based on the initialized restore request.
The restore job can be seen on the portal or can be tracked using its operation id.

## PARAMETERS

### -ContainerName
Container name where restore is to be done.

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

### -DefaultProfile


```yaml
Type: System.Management.Automation.PSObject
Parameter Sets: (All)
Aliases: AzureRMContext, AzureCredential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProtectedItemName
Name of the protected item which is to be restored.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecoveryPointId
Recovery point Id for the restore.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Request
Restore request object to be sent to the service.
To construct, see NOTES section for REQUEST properties and create a hash table.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRestoreRequest
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
The name of the resource group where the recovery services vault is present.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultName
The name of the recovery services vault.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRestoreRequest

## NOTES

ALIASES

COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.


`REQUEST <IRestoreRequest>`: Restore request object to be sent to the service.
  - `ObjectType <String>`: This property will be used as the discriminator for deciding the specific types in the polymorphic chain of types.

## RELATED LINKS

