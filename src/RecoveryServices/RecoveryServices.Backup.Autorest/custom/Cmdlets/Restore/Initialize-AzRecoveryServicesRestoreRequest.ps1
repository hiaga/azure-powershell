function Initialize-AzRecoveryServicesRestoreRequest {
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.RestoreRequest')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Initializes Restore Request object for triggering restore on a protected backup instance.')]

	param (
        # Recovery point and type specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DatasourceType')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the recovery point.')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRecoveryPointResource]
        ${RecoveryPoint},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the RecoveryType.')]
        [string]
        ${RecoveryType},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the RecoveryMode.')]
        [string]
        ${RecoveryMode},

        # Target specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target subscriptionId.')]
        [string]
        ${TargetSubscriptionId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target resourceGroupName.')]
        [string]
        ${TargetResourceGroupName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the name of target VM to which we restore.')]
        [string]
        ${TargetVMName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId in which target VM is created.')]
        [string]
        ${TargetContainerId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory in which restore file is created.')]
        [string]
        ${TargetDirectory},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target DB name which is created.')]
        [string]
        ${TargetDatabaseName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the name of the target VNet.')]
        [string]
        ${TargetVNetName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the resourceGroupName of the target VNet.')]
        [string]
        ${TargetVNetResourceGroup},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target subnet name.')]
        [string]
        ${TargetSubnetName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target zone number.')]
        [int]
        ${TargetZoneNumber},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the OverwriteOption in case of conflicting names.')]
        #[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.OverwriteOptions]
        [string]
        ${OverwriteOption},

        # AzureVM specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target StorageAccountId.')]
        [string]
        ${StorageAccountId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target region.')]
        [string]
        ${Region},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DiskEncryptionSetId.')]
        [string]
        ${DiskEncryptionSetId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the list of restore disks.')]
        [string[]]
        ${RestoreDiskList},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies whether we need to restore only the OS disk.')]
        [switch]
        ${RestoreOnlyOSDisk},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies whether we need to use the system assigned identity.')]
        [switch]
        ${UseSystemAssignedIdentity},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies user assigned identity.')]
        [string]
        ${UserAssignedIdentityId},

        # SQL specific parameters
        
        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies whether we need to set NonRecoverable option.')]
        [bool]
        ${NonRecoverable},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DataSourceLogicalName.')]
        [string]
        ${DataSourceLogicalName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DataSourcePath.')]
        [string]
        ${DataSourcePath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DataTargetPath.')]
        [string]
        ${DataTargetPath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the LogSourceLogicalName.')]
        [string]
        ${LogSourceLogicalName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the LogSourcePath.')]
        [string]
        ${LogSourcePath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the LogTargetPath.')]
        [string]
        ${LogTargetPath},

        # Rehydrate specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the rehydrate duration.')]
        [string]
        ${RehydrateDuration},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the rehydrate priority.')]
        [string]
        ${RehydratePriority}
    )

    begin {  
        # Call validation function here
    }

    process {
        
        # Decide the type of Restore based on RecoveryPoint
        
        # SAPHANA cases
        if ($DataSourceType -eq "SAPHANA") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSapHanaRestoreRequest]::new()

            if (($RecoveryType -eq "AlternateLocation") -and (-not $RecoveryMode)) {
                Write-Debug "AlternateLocation"
            
                $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.DatabaseName = $TargetDatabaseName
                $restoreRequest.TargetInfo.OverwriteOption = $OverwriteOption

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint
                
                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
                
                $restoreRequest.RecoveryType = $RecoveryType
            }
            elseif ($RecoveryType -eq "OriginalLocation") {

                Write-Debug "OriginalLocation"

                $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
                $restoreRequest.RecoveryType = $RecoveryType
		    }
            elseif (($RecoveryType -eq "AlternateLocation") -and ($RecoveryMode -eq "FileRecovery")) {
                
                Write-Debug "As File"

			    $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
			    $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.TargetDirectoryForFileRestore = $TargetDirectory

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

			    $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId

                $restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.RecoveryMode = $RecoveryMode
            }
        }

        # AzureVM cases

        elseif ($DataSourceType -eq "AzureVM") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IaaSVMRestoreRequest]::new()

            if ($RecoveryType -eq "AlternateLocation") {
                Write-Debug "AzureVM new vm"

                $restoreRequest.ObjectType = "IaasVMRestoreRequest"
                $restoreRequest.RecoveryPointId = $RecoveryPoint.Id
                $restoreRequest.RecoveryType = $RecoveryType

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint
				
                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId

                $TargetResourceGroupId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName"
                $restoreRequest.TargetResourceGroupId = $TargetResourceGroupId

                $restoreRequest.StorageAccountId = $StorageAccountId

                $TargetVNetId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetVNetResourceGroup/providers/Microsoft.Network/virtualNetworks/$TargetVNetName" 
                $restoreRequest.VirtualNetworkId = $TargetVNetId

                $TargetSubnetId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetVNetResourceGroup/providers/Microsoft.Network/virtualNetworks/$TargetVNetName/subnets/$TargetSubnetName"
                $restoreRequest.SubnetId = $TargetSubnetId

                $restoreRequest.Region = $Region
                #$restoreRequest.DiskEncryptionSetId = $DiskEncryptionSetId
                #$restoreRequest.RestoreDiskLunList = $RestoreDiskList
                # OS disk?

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
                $restoreRequest.RestoreWithManagedDisk = $false
            }
            elseif ($RecoveryType -eq "RestoreDisks") {
                Write-Debug "AzureVM restore disks"

				$restoreRequest.ObjectType = "IaasVMRestoreRequest"
				$restoreRequest.RecoveryPointId = $RecoveryPoint.Id
				$restoreRequest.RecoveryType = $RecoveryType

				$restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

                $TargetResourceGroupId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName"
                $restoreRequest.TargetResourceGroupId = $TargetResourceGroupId
                
                $restoreRequest.StorageAccountId = $StorageAccountId
                $restoreRequest.Region = $Region

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
                $restoreRequest.RestoreWithManagedDisk = $false
            }
            elseif ($RecoveryType -eq "OriginalLocation") {
                Write-Debug "AzureVM original location"

                $restoreRequest.ObjectType = "IaasVMRestoreRequest"
                $restoreRequest.RecoveryPointId = $RecoveryPoint.Id
                $restoreRequest.RecoveryType = $RecoveryType
                
                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

                $restoreRequest.StorageAccountId = $StorageAccountId
                $restoreRequest.Region = $Region

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
            }
        }

        # SQL cases

        elseif ($ObjectType -eq "MSSQL") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSqlRestoreRequest]::new()
			
            if (($RecoveryType -eq "AlternateLocation") -and (-not $RecoveryMode)) {
				Write-Debug "SQL alternate"
            
				$restoreRequest.ObjectType = "AzureWorkloadSQLRestoreRequest"
				$restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.ShouldUseAlternateTargetLocation = $true
                
                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.DatabaseName = $DatabaseName
                $restoreRequest.TargetInfo.OverwriteOption = $OverwriteOption

                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
				
                $restoreRequest.IsNonRecoverable = $NonRecoverable
				$restoreRequest.SourceResourceId = $SourceResourceId

                $restoreRequest.AlternateDirectoryPath = @()
                
                $DataDirectoryMapping = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SqlDataDirectoryMapping]::new()
                $DataDirectoryMapping.MappingType = "Data"
                $DataDirectoryMapping.SourceLogicalName = $DataSourceLogicalName
                $DataDirectoryMapping.SourcePath = $DataSourcePath
                $DataDirectoryMapping.TargetPath = $DataTargetPath
                $restoreRequest.AlternateDirectoryPath += $DataDirectoryMapping

                $LogDirectoryMapping = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SqlDataDirectoryMapping]::new()
                $LogDirectoryMapping.MappingType = "Log"
				$LogDirectoryMapping.SourceLogicalName = $LogSourceLogicalName
				$LogDirectoryMapping.SourcePath = $LogSourcePath
				$LogDirectoryMapping.TargetPath = $LogTargetPath
				$restoreRequest.AlternateDirectoryPath += $LogDirectoryMapping
            }
            elseif ($RecoveryType -eq "OriginalLocation") {
                Write-Debug "SQL original"

                $restoreRequest.ObjectType = "AzureWorkloadSQLRestoreRequest"
                $restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.ShouldUseAlternateTargetLocation = $true
                $restoreRequest.IsNonRecoverable = $NonRecoverable
            }
            elseif (($RecoveryType -eq "AlternateLocation") -and ($RecoveryMode -eq "FileRecovery")) {
				Write-Debug "SQL restore as files"
				
                $restoreRequest.ObjectType = "AzureWorkloadSQLRestoreRequest"
				$restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.RecoveryMode = $RecoveryMode

                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.TargetDirectoryForFileRestore = $TargetDirectory

                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
				
                $restoreRequest.SourceResourceId = $SourceResourceId
			}
        }

        # PointInTime cases

        if ($ObjectType -eq "AzureWorkloadSAPHanaPointInTimeRestoreRequest") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSapHanaPointInTimeRestoreRequest]::new()
		}
        elseif ($ObjectType -eq "AzureWorkloadSQLPointInTimeRestoreRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSqlPointInTimeRestoreRequest]::new()
        }

        # Rehydrate cases

        if ($ObjectType -eq "AzureWorkloadSAPHanaRestoreWithRehydrateRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSapHanaRestoreWithRehydrateRequest]::new()
        }
        elseif ($ObjectType -eq "IaasVMRestoreWithRehydrationRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IaasVMRestoreWithRehydrationRequest]::new()
        }
        elseif ($ObjectType -eq "AzureWorkloadSQLRestoreWithRehydrateRequest") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSqlRestoreWithRehydrateRequest]::new()
		}

        $restoreRequest
    }
}