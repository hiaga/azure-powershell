function New-AzRecoveryServicesBackupPolicy
{
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicyResource')]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Creates a new backup policy in a given recovery services vault')]

	param(
        [Parameter(Mandatory=$false, HelpMessage='Subscription Id')]
        [System.String]
        ${SubscriptionId},

        [Parameter(Mandatory, HelpMessage='The name of the resource group where the recovery services vault is present.')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(Mandatory, HelpMessage='The name of the recovery services vault.')]
        [System.String]
        ${VaultName},

        [Parameter(Mandatory, HelpMessage='Policy Name for the policy to be created')]
        [System.String]
        ${PolicyName},

        [Parameter(Mandatory, HelpMessage='Workload specific Backup policy object.')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicy]
        ${Policy},

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
        ${ProxyUseDefaultCredentials},
            
        [Parameter(Mandatory=$false)]
        [Nullable[System.Boolean]]
        ${MoveToArchiveTier},
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('TierRecommended', 'TierAfter')]
        [string]
        ${TieringMode},
        
        [Parameter(Mandatory=$false)]
        [Nullable[int]]
        ${TierAfterDuration},

        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -ge 1 -and $_ -le 5}, ErrorMessage = "The value of SnapshotRetentionDurationInDays must be between 1 and 5.")]
        [Nullable[int]]
        ${SnapshotRetentionDurationInDays}
        
    )

    process
    {   
        #get datasource type
        $BackupManagementType = $policy.BackupManagementType
        $WorkloadType = $policy.WorkLoadType
        $DataSourceType = Get-DataSourceType -BackupManagementType $BackupManagementType -WorkloadType $WorkloadType
        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()

        if($SnapshotRetentionDurationInDays -ne $null)
        {
            $policy.instantRpRetentionRangeInDay=$SnapshotRetentionDurationInDays
            if(($policy.SchedulePolicy.ScheduleRunFrequency -eq "Weekly") -and ($policy.instantRpRetentionRangeInDay -ne 5))
            {
                $errormsg="SnapshotRetentionDuration value must be 5 for backup policy with frequency of schedule as Weekly"
                throw $errormsg
            }
        }

        if($MoveToArchiveTier -ne $null)
        {
            if($policy.BackupManagementType -eq "AzureIaasVM")
            {
                 $tieringdetails = $policy.TieringPolicy.AdditionalProperties.ArchivedRP
            }
            elseif($policy.BackupManagementType -eq "AzureWorkload")
            {
                $FullBackupPolicy =  $policy.SubProtectionPolicy | where { $_.PolicyType -match "Full" }
                $Index = $policy.SubProtectionPolicy.IndexOf($FullBackupPolicy)
                $tieringdetails =$policy.SubProtectionPolicy[$Index].TieringPolicy.AdditionalProperties.ArchivedRP
            }
            
            if($manifest.IsTieringSupported -ne "True")
            {
                $errormsg="Smart tiering not supported for given workload type"
                throw $errormsg
            }
            if($MoveToArchiveTier -eq $false)   #if tiering disabled
            {
                if(($TieringMode -ne "") -or ($TierAfterDuration -ne $null))
                {
                    $errormsg= "Invalid parameters for disable tiering"
                    throw $errormsg
                }
                $tieringdetails.TieringMode="DoNotTier"
                $tieringdetails.duration=$null
                $tieringdetails.durationType=$null
            }
            else #if tiering enabled
            {
                if(($policy.backupManagementType -eq "AzureWorkload") -and ($tieringdetails.TieringMode -eq "TierRecommended"))
                {
                    $errormsg="TierRecommended not supported for AzureWorkload"
                    throw $errormsg
                }
                if($TieringMode -ne $null){
                    $tieringdetails.TieringMode=$TieringMode
                }
                if($TierAfterDuration -ne $null){
                    $tieringdetails.duration=$TierAfterDuration
                }
                if($policy.backupManagementType -eq "AzureWorkload"){
                    $tieringdetails.durationType="Days"
                }
                elseif($policy.backupManagementType -eq "AzureIaasVM"){
                    $tieringdetails.durationType="Months"
                }
                if($tieringdetails.TieringMode -eq "TierRecommended")
                {
                    $tieringdetails.duration=0
                    $tieringdetails.durationType="Invalid"
                }
                 #Validation
                ValidateTieringPolicy
            }
      
        }
        $null = $PSBoundParameters.Remove("SnapshotRetentionDurationInDays")
        $null = $PSBoundParameters.Remove("MoveToArchiveTier")
        $null = $PSBoundParameters.Remove("TieringMode")
        $null = $PSBoundParameters.Remove("TierAfterDuration")


        # RsvRef
        # public string[] ResourceGuardOperationRequest --- this should be a parameter (check in SDK code) ? If yes, optional parameters ? 
                
        # RsvRef : add policy validation (preferably one entry point)
        
        $policyObject = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.ProtectionPolicyResource]::new()
        $policyObject.Property = $Policy

        
        
        $null = $PSBoundParameters.Remove("Policy")
        $null = $PSBoundParameters.Add("Parameter", $policyObject)

        # RsvRef : change command name while taking a pull or modify the directive
        Az.RecoveryServices.Internal\New-AzRecoveryServicesBackupPolicy @PSBoundParameters
    }
}