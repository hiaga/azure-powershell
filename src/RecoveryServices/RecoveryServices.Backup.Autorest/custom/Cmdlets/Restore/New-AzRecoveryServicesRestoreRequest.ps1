function New-AzRecoveryServicesRestoreRequest
{
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRestoreRequest')]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Triggers restore for the backup item to the specified recovery point.')]

	param(
        [Parameter(Mandatory=$false, HelpMessage='Container name where restore is to be done.')]
        [System.String]
        ${ContainerName},

        [Parameter(Mandatory, HelpMessage='The name of the resource group where the recovery services vault is present.')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(Mandatory, HelpMessage='The name of the recovery services vault.')]
        [System.String]
        ${VaultName},

        [Parameter(Mandatory, HelpMessage='Name of the protected item which is to be restored.')]
        [System.String]
        ${ProtectedItemName},

        [Parameter(Mandatory, HelpMessage='Recovery point Id for the restore.')]
        [System.String]
        ${RecoveryPointId},

        [Parameter(Mandatory, HelpMessage='Restore request object to be sent to the service.')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRestoreRequest]
        ${Request},
    
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
              
        $requestObject = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.RestoreRequestResource]::new()

        $requestObject.Property = $Request 

        
        $null = $PSBoundParameters.Remove("Request")
        $null = $PSBoundParameters.Add("FabricName", "Azure")
        $null = $PSBoundParameters.Add("NoWait", $true)
        $null = $PSBoundParameters.Add("Parameter", $requestObject)

        # TODO : change command name while taking a pull or modify the directive
        $restoreOperation = Start-AzRecoveryServicesRestore @PSBoundParameters
            
        Write-Debug -Message "Restore operation : $restoreOperation"
        
        $operationId = $restoreOperation.Target.Split("/")[-1].Split("?")[0]

        Write-Debug -Message "Operation Id : $operationId"

        #While($true)
        #{
	    #    Start-Sleep -Seconds 2
	    #    $status = Get-AzRecoveryServicesOperationStatus -OperationId $operationId -ResourceGroupName saphana-eus-pstest-rg -SubscriptionId 38304e13-357e-405e-9e9a-220351dcce8c -VaultName saphana-eus-pstest-vault
	    #    Write-Debug -Message "Current status : $status.Status"
	    #    if($status.Status -eq "Inprogress") {
		#        continue
	    #    }
	    #    else {
		#        break
	    #    }
        #}
    }
}