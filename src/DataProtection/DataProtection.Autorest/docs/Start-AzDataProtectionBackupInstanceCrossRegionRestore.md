---
external help file:
Module Name: Az.DataProtection
online version: https://learn.microsoft.com/powershell/module/az.dataprotection/start-azdataprotectionbackupinstancecrossregionrestore
schema: 2.0.0
---

# Start-AzDataProtectionBackupInstanceCrossRegionRestore

## SYNOPSIS


## SYNTAX

### Trigger (Default)
```
Start-AzDataProtectionBackupInstanceCrossRegionRestore -Location <String> -ResourceGroupName <String>
 -Parameter <ICrossRegionRestoreRequestObject> [-SubscriptionId <String>] [-DefaultProfile <PSObject>]
 [-AsJob] [-NoWait] [-Confirm] [-WhatIf] [<CommonParameters>]
```

### TriggerExpanded
```
Start-AzDataProtectionBackupInstanceCrossRegionRestore -Location <String> -ResourceGroupName <String>
 -CrossRegionRestoreDetailSourceBackupInstanceId <String> -CrossRegionRestoreDetailSourceRegion <String>
 -RestoreRequestObjectRestoreTargetInfo <IRestoreTargetInfoBase>
 -RestoreRequestObjectSourceDataStoreType <SourceDataStoreType> -RestoreRequestObjectType <String>
 [-SubscriptionId <String>] [-IdentityDetailUserAssignedIdentityArmUrl <String>]
 [-IdentityDetailUseSystemAssignedIdentity] [-RestoreRequestObjectSourceResourceId <String>]
 [-DefaultProfile <PSObject>] [-AsJob] [-NoWait] [-Confirm] [-WhatIf] [<CommonParameters>]
```

## DESCRIPTION


## EXAMPLES

### Example 1: {{ Add title here }}
```powershell
{{ Add code here }}
```

```output
{{ Add output here }}
```

{{ Add description here }}

### Example 2: {{ Add title here }}
```powershell
{{ Add code here }}
```

```output
{{ Add output here }}
```

{{ Add description here }}

## PARAMETERS

### -AsJob
Run the command as a job

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

### -CrossRegionRestoreDetailSourceBackupInstanceId
.

```yaml
Type: System.String
Parameter Sets: TriggerExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CrossRegionRestoreDetailSourceRegion
.

```yaml
Type: System.String
Parameter Sets: TriggerExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultProfile
The DefaultProfile parameter is not functional.
Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.

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

### -IdentityDetailUserAssignedIdentityArmUrl
ARM URL for User Assigned Identity.

```yaml
Type: System.String
Parameter Sets: TriggerExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdentityDetailUseSystemAssignedIdentity
Specifies if the BI is protected by System Identity.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: TriggerExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
.

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

### -NoWait
Run the command asynchronously

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

### -Parameter
Cross Region Restore Request Object
To construct, see NOTES section for PARAMETER properties and create a hash table.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20230801Preview.ICrossRegionRestoreRequestObject
Parameter Sets: Trigger
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ResourceGroupName
The name of the resource group.
The name is case insensitive.

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

### -RestoreRequestObjectRestoreTargetInfo
Gets or sets the restore target information.
To construct, see NOTES section for RESTOREREQUESTOBJECTRESTORETARGETINFO properties and create a hash table.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20230801Preview.IRestoreTargetInfoBase
Parameter Sets: TriggerExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestoreRequestObjectSourceDataStoreType
Gets or sets the type of the source data store.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.SourceDataStoreType
Parameter Sets: TriggerExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestoreRequestObjectSourceResourceId
Fully qualified Azure Resource Manager ID of the datasource which is being recovered.

```yaml
Type: System.String
Parameter Sets: TriggerExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestoreRequestObjectType
.

```yaml
Type: System.String
Parameter Sets: TriggerExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
The ID of the target subscription.
The value must be an UUID.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-AzContext).Subscription.Id
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

### Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20230801Preview.ICrossRegionRestoreRequestObject

## OUTPUTS

### Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20230801Preview.IOperationJobExtendedInfo

## NOTES

## RELATED LINKS

