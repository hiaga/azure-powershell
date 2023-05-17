# takes backupmanagement type and workload type as i/p & gives dataspurce type
function Get-DataSourceType {
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]

    param(
        [string]$BackupManagementType,
        [string]$WorkloadType
    )

    if ($BackupManagementType -eq "AzureWorkload") {
        if ($WorkloadType -eq "SAPHanaDatabase") {
            return "SAPHANA"
        }
        elseif ($WorkloadType -eq "SQLDataBase") {
            return "MSSQL"
        }
    }
    elseif ($BackupManagementType -eq "AzureIaasVM") {
        return "AzureVM"
    }
    elseif($BackupManagementType -eq "AzureStorage"){
        return "AzureFiles"
    }

    # Return null if no match found
    return $null
}

# Summary: get service client backupmanagement type from datasource type
function GetBackupManagementTypeFromDataSourceType {
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]

    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $DataSourceType
    )

    process {
        # TODO: can this be manifest based directly? 
        if($DataSourceType -eq "AzureVM"){
            return "AzureIaasVM"
        }

        elseif ($DataSourceType -eq "MSSQL" -or $DataSourceType -eq "SAPHANA") {
            return "AzureWorkload"
        }        
        
        elseif($DataSourceType -eq "AzureFiles"){
            return "AzureStorage"
        }

        elseif($DataSourceType -eq "MAB"){
            return "MAB"
        }

        # Return null if no match found
        return $null
    }
}

# Get service client Item type from datasourcetype
# can be used as GetWorkloadTypeFromDataSourceType
function GetItemTypeFromDataSourceType { 
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
    
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $DataSourceType
    )

    process {
        
        if($DataSourceType -eq "AzureVM"){
            return "VM"
        }

        elseif ($DataSourceType -eq "MSSQL") {
            return "SQLDataBase"
        }        
        
        elseif($DataSourceType -eq "AzureFiles"){
            return "AzureFileShare"
        }

        elseif($DataSourceType -eq "SAPHANA"){
            return "SAPHanaDatabase"
        }

        return $null
    }
}

# Summary: get datasourcetype from datasource type from policy
function GetDatasourceTypeFromPolicy {
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]

    param(
        [Parameter(Mandatory=$true)]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicyResource]
        $Policy
    )

    process {
        
        $DataSourceType = Get-DataSourceType -BackupManagementType $Policy.BackupManagementType -WorkloadType $Policy.Property.WorkLoadType
        return $DataSourceType
    }
}

# Summary: takes OerationRepsonse.Target as input, tracks the operationStatus to Success/Failure
function GetOperationStatus {
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]

    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Target,

        [Parameter(Mandatory=$false)]
        [System.String]
        $RefreshAfter = 10
    )

    process {
        
        $operationId = $Target.Split("/")[-1].Split("?")[0]
        $resourceGroupName = Get-ResourceGroupNameFromArmId -Id $Target
        $vaultName = Get-VaultNameFromArmId -Id $Target
        $subscriptionId = Get-SbscriptionIdFromArmId -Id $Target


        # operationStatus
        While((Get-AzRecoveryServicesOperationStatus -OperationId $operationId -ResourceGroupName $resourceGroupName -SubscriptionId $subscriptionId -VaultName $vaultName).Status -eq "InProgress"){

            Write-Debug "Polling after $RefreshAfter seconds"
	        Start-Sleep -Seconds $RefreshAfter
        }

        $operationStatus = (Get-AzRecoveryServicesOperationStatus -OperationId $operationId -ResourceGroupName $resourceGroupName -SubscriptionId $subscriptionId -VaultName $vaultName).Status

        return $operationStatus
    }
}