function Register-AzRecoveryServicesBackupContainer
{
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionContainerResource')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('The Register-AzRecoveryServicesBackupContainer cmdlet registers an Azure VM for AzureWorkloads with specific DatasourceType.')]

	param(
        [Parameter(Mandatory=$false, HelpMessage='Subscription Id')]
        [System.String]
        ${SubscriptionId},

        [Parameter(Mandatory, HelpMessage='The name of the resource group where the recovery services vault is present')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(Mandatory, HelpMessage='The name of the recovery services vault')]
        [System.String]
        ${VaultName},

        [Parameter(Mandatory=$true, Position=1, HelpMessage='Specifies the DatasourceType')]        
        [ValidateSet("MSSQL", "SAPHANA", ErrorMessage = "Invalid value for DatasourceType. Please provide a valid datasource type. Valid values are 'MSSQL'")]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName="ReRegister", Mandatory=$true, Position=0, HelpMessage='Specifies a container object for which this cmdlet triggers the re-registration. To obtain an ProtectionContainerResource, use the Get-AzRecoveryServicesBackupContainer cmdlet', ValueFromPipelineByPropertyName=$true)]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionContainerResource]
        ${Container},

        [Parameter(ParameterSetName="Register", Position=0, Mandatory=$true, HelpMessage='Specifies the ARM ID of an Instance or Availability Group')]
        [System.String]
        ${ResourceId},
                
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}        
    )

    process
    {           
        $parameterSetName = $PsCmdlet.ParameterSetName       
        
        Write-Host "Subscription ID: $SubscriptionId"
        Write-Host "$($SubscriptionId.GetType())"

        $containerName = ""
        if($parameterSetName -eq "ReRegister"){
            $containerName = ($Container.Name -split ";")[-1]
        }
        else{
            $containerName = ($ResourceId -split "/")[-1]
        }
        
        Write-Host "reached .... param set name: $parameterSetName"
        Write-Host "reached .... $($Container.Name)"
        Write-Host "reached .... $($Container -ne $null)"

        # confirm:$false/ force  
        #$containerType - workload type 
        #$backupManagementType
        #$container = $Container

        # Refresh containers
        $filter = Get-BackupManagementTypeFilter -DatasourceType $DatasourceType
        
        Write-Host "reached .... 1"
        $refreshOperationResponse = Update-AzRecoveryServicesProtectionContainer -FabricName "Azure" -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -VaultName $VaultName -Filter $filter -NoWait

        Write-Host "reached .... 2"
        $operationStatus = GetOperationStatus -Target $refreshOperationResponse.Target
        
        Write-Host "reached .... 2a $operationStatus"
        Write-Host "reached .... 2a $($operationStatus -ne "Succeeded")"
        if($operationStatus -ne "Succeeded"){
            $errormsg= "Refresh container operation failed with operationStatus: $operationStatus"
            throw $errormsg
        }
        
        Write-Host "reached .... 3"
        # Get protectable containers  (register) / container (re-register)
        $protectableContainers = Get-AzRecoveryServicesProtectableContainer -FabricName "Azure" -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -VaultName $VaultName -Filter $filter | Where-Object { ($_.Name -split ";")[-1] -eq $containerName -or $_.Name -eq $containerName }

        Write-Host "reached .... 4"
        Write-Host "reached .... param set name: $parameterSetName"
        Write-Host "reached .... $($Container.Name)"
        Write-Host "reached .... $($Container -ne $null)"
        if($protectableContainers -ne $null -or $Container -ne $null){
            $protectionContainerResource = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.ProtectionContainerResource]::new()

            Write-Host "reached .... 5"
            $containerFullName = ($Container -ne $null) ? $Container.Name : $protectableContainers.Name

            $property = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureVMAppContainerProtectionContainer]::new()

            $property.FriendlyName = $containerName
            $property.BackupManagementType = GetBackupManagementTypeFromDataSourceType -DatasourceType $DatasourceType 
            $property.SourceResourceId = ($Container -ne $null) ? $Container.Property.SourceResourceId : $protectableContainers.ContainerId
            $property.WorkloadType = GetItemTypeFromDataSourceType -DatasourceType $DatasourceType
            $property.OperationType = ($Container -ne $null) ? "Reregister" : "Register"
            $property.ContainerType = "VMAppContainer"

            $protectionContainerResource.Property = $property

            Write-Host "reached .... 6"
            # register container
            $registerOperationResponse = Register-AzRecoveryServicesProtectionContainer -ContainerName $containerFullName -FabricName "Azure" -ResourceGroupName $ResourceGroupName -SubscriptionId $SubscriptionId -VaultName $VaultName -Parameter $protectionContainerResource -NoWait        

            Write-Host "reached .... 7"
            $operationStatus = GetOperationStatus -Target $registerOperationResponse.Target            

            if($operationStatus -ne "Succeeded"){
                $errormsg= "Register container operation failed with operationStatus: $operationStatus"
                throw $errormsg
            }
            Write-Host "reached .... 8"
        }
        else{
            # throw error 
            $errormsg= "The specified datasource is already registered with the given recovery services vault"
            throw $errormsg            
        }
        
        Write-Host "reached .... 9"
        # List containers
        $registeredContainer = Get-AzRecoveryServicesBackupContainer -ResourceGroupName $ResourceGroupName -VaultName $VaultName -SubscriptionId $SubscriptionId -ContainerType AzureVMAppContainer -DatasourceType $DatasourceType | Where-Object { $_.Name -eq $containerFullName }

        Write-Host "reached .... 10"
        $registeredContainer
    }
}