---
external help file: Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Backup.dll-Help.xml
Module Name: Az.RecoveryServices
online version:
schema: 2.0.0
---

# Update-AzRecoveryServicesBackupEncryption

## SYNOPSIS
Updates the encyption properties for the recovery services vault.

## SYNTAX

```
Update-AzRecoveryServicesBackupEncryption [-VaultId <String>] [-DefaultProfile <IAzureContextContainer>]
 -EncryptionKeyName <String> -EncryptionKeyVaultName <String> [-EncryptionKeyVersion <String>]
 -KeyVaultSubscriptionId <String> [-InfrastructureEncryption] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the encyption properties for the recovery services vault. This cmdlet is used to add CMK to the vault.

## EXAMPLES

### Example 1
```powershell
PS C:\> $vault = Get-AzRecoveryServicesVault -ResourceGroupName "rgName" -Name "vaultName"
PS C:\> Update-AzRecoveryServicesBackupEncryption -EncryptionKeyName "encryptionKeyName" -EncryptionKeyVaultName "keyVaultName" -KeyVaultSubscriptionId "f870818k-5h28-4t48-8961-37458592348r" -EncryptionKeyVersion "50yc6bc287654d7abf263d6914r2c213"  -VaultId $vault.ID
```

First cmdlet gets the RSVault to update encryption properties. Second cmdlet updates the customer managed encryption key within the RSVault. Use -InfrastructureEncryption param to enable infrastructure encryption. 

## PARAMETERS

### -DefaultProfile
The credentials, account, tenant, and subscription used for communication with Azure.

```yaml
Type: IAzureContextContainer
Parameter Sets: (All)
Aliases: AzContext, AzureRmContext, AzureCredential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionKeyName
Name of the encryption key to be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionKeyVaultName
Name of the Key vault where encryption key is stored.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptionKeyVersion
Version of the encryption key.
Required only if auto-update is to be disabled.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InfrastructureEncryption
Enables the Infrastructure level encryption.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyVaultSubscriptionId
Subscription Id where the key vault is created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultId
ARM ID of the Recovery Services Vault.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
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
Type: SwitchParameter
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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
