function Initialize-AzDataProtectionRestoreRequest
{
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.IAzureBackupRestoreRequest')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Initializes Restore Request object for triggering restore on a protected backup instance.')]

    param(
        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory, HelpMessage='Datasource Type')]
        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='Datasource Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='DataStore Type of the Recovery point')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DataStoreType]
        ${SourceDataStore},

        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory, HelpMessage='Target Restore Location')]
        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='Target Restore Location')]
        [System.String]
        ${RestoreLocation},

        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory, HelpMessage='Restore Target Type')]
        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='Restore Target Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.RestoreTargetType]
        ${RestoreType},

        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory=$false, HelpMessage='Target resource Id to which backup data will be restored.')]
        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='Target resource Id to which backup data will be restored.')]
        [System.String]
        ${TargetResourceId},

        [Parameter(ParameterSetName="RecoveryPointBased", Mandatory, HelpMessage='Id of the recovery point to be restored.')]
        [System.String]
        ${RecoveryPoint},

        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory, HelpMessage='Point In Time for restore.')]
        [System.String]
        ${RecoveryPointTime},

        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory=$false, HelpMessage='Container names for Item Level Recovery.')]
        [System.String[]]
        ${ContainersList},

        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory=$false, HelpMessage='Minimum matching value for Item Level Recovery.')]
        [System.String[]]
        ${FromPrefixPattern},

        [Parameter(ParameterSetName="RecoveryTimeBased", Mandatory=$false, HelpMessage='Maximum matching value for Item Level Recovery.')]
        [System.String[]]
        ${ToPrefixPattern}
    )

    process
    {         
        # Validations
        $parameterSetName = $PsCmdlet.ParameterSetName
        
        # if container Name is given - it should be ILR
        ValidateRestoreOptions -DatasourceType $DatasourceType -RestoreMode $parameterSetName -RestoreTargetType $RestoreType

        $restoreRequest = $null
        # Choose Restore Request Type Based on Mode
        if($parameterSetName -eq "RecoveryPointBased")
        {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.AzureBackupRecoveryPointBasedRestoreRequest]::new()
            $restoreRequest.ObjectType = "AzureBackupRecoveryPointBasedRestoreRequest"
            $restoreRequest.RecoveryPointId = $RecoveryPoint
        }
        elseif($parameterSetName -eq "RecoveryTimeBased") # RecoveryTimeBased 
        {  
            Write-Debug -Message $RestoreType 
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.AzureBackupRecoveryTimeBasedRestoreRequest]::new()
            $restoreRequest.ObjectType = "AzureBackupRecoveryTimeBasedRestoreRequest"
            $restoreRequest.RecoveryPointTime = $RecoveryPointTime

            # print the restore object after commenting all below
        }

        # Initialize Restore Target Info based on Type provided
        if(($RestoreType -eq "AlternateLocation") -or ($RestoreType -eq "OriginalLocation"))
        {
            
            $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.RestoreTargetInfo]::new()
            $restoreRequest.RestoreTargetInfo.ObjectType = "RestoreTargetInfo"
        }
        if($RestoreType -eq "RestoreAsFiles")
        {
            $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.RestoreFilesTargetInfo]::new()
            $restoreRequest.RestoreTargetInfo.ObjectType = "RestoreFilesTargetInfo"
        }
        if($RestoreType -eq "ItemLevelRecovery")
        {
            $restoreRequest.RestoreTargetInfo = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.ItemLevelRestoreTargetInfo]::new()
            $restoreRequest.RestoreTargetInfo.ObjectType = "ItemLevelRestoreTargetInfo"

            $restoreCriteriaList = @()
            
            if($ContainersList.length -gt 0){                
                for($i = 0; $i -lt $ContainersList.length; $i++){
                                
                    $restoreCriteria =  [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.RangeBasedItemLevelRestoreCriteria]::new()

                    $restoreCriteria.ObjectType = "RangeBasedItemLevelRestoreCriteria"
                    $restoreCriteria.MinMatchingValue = $ContainersList[$i]
                    $restoreCriteria.MaxMatchingValue = $ContainersList[$i] + "-0"

                    # adding a criteria for each container given
                    $restoreCriteriaList += ($restoreCriteria)
                }
            }
            elseif($FromPrefixPattern.length -gt 0){
                
                if(($FromPrefixPattern.length -ne $ToPrefixPattern.length) -or ($FromPrefixPattern.length -gt 10) -or ($ToPrefixPattern.length -gt 10)){
                    $errormsg = "FromPrefixPattern and ToPrefixPattern parameters maximum length can be 10 and must be equal "
    			    throw $errormsg
                }
                
                for($i = 0; $i -lt $FromPrefixPattern.length; $i++){
                                
                    $restoreCriteria =  [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api202101.RangeBasedItemLevelRestoreCriteria]::new()

                    $restoreCriteria.ObjectType = "RangeBasedItemLevelRestoreCriteria"
                    $restoreCriteria.MinMatchingValue = $FromPrefixPattern[$i]
                    $restoreCriteria.MaxMatchingValue = $ToPrefixPattern[$i]

                    # adding a criteria for each container given
                    $restoreCriteriaList += ($restoreCriteria)
                }                
            }    
            else{
                 $errormsg = "Provide -ContainersList for Item Level Recovery"
    			 throw $errormsg            
            }

            $restoreRequest.RestoreTargetInfo.RestoreCriterion = $restoreCriteriaList
        }

        # Fill other fields of Restore Object based on inputs given        
        $restoreRequest.SourceDataStoreType = $SourceDataStore
        $restoreRequest.RestoreTargetInfo.RestoreLocation = $RestoreLocation

        if( ($TargetResourceId -ne $null) -and ($TargetResourceId -ne "") )
        {
            if($RestoreType -eq "AlternateLocation")
            {
                $restoreRequest.RestoreTargetInfo.DatasourceInfo = GetDatasourceInfo -ResourceId $TargetResourceId -ResourceLocation $RestoreLocation -DatasourceType $DatasourceType
                $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
                if($manifest.isProxyResource -eq $true)  # check with Sambit if this is needed for Blobs
                {
                    $restoreRequest.RestoreTargetInfo.DatasourceSetInfo = GetDatasourceSetInfo -DatasourceInfo $restoreRequest.RestoreTargetInfo.DatasourceInfo
                }
            }

            # if blobs workload,original Location or ILR - get DatasourceInfo and assign
            if($DatasourceType.ToString() -eq "AzureBlob")
            {   
                $dsInfo = GetDatasourceInfo -ResourceId $TargetResourceId -ResourceLocation $RestoreLocation -DatasourceType $DatasourceType      
                
                if($RestoreType -eq "ItemLevelRecovery"){
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoObjectType = $dsInfo.ObjectType
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoResourceId = $dsInfo.ResourceId
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoResourceLocation = $dsInfo.ResourceLocation
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoResourceName = $dsInfo.ResourceName
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoResourceType = $dsInfo.ResourceType
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoResourceUri = $dsInfo.ResourceUri
                    $restoreRequest.RestoreTargetInfo.DatasourceInfoDatasourceType = $dsInfo.Type
                }                
                else{ # for OLR
                    $restoreRequest.RestoreTargetInfo.DatasourceInfo = $dsInfo
                }                
            }
        }        

        return $restoreRequest
    }
}