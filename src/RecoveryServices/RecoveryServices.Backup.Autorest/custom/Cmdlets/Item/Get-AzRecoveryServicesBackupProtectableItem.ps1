function Get-AzRecoveryServicesBackupProtectableItem
{
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IWorkloadProtectableItemResource')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('This command will retrieve all protectable items within a certain container or across all registered containers. It will consist of all the elements of the hierarchy of the application. Returns DBs and their upper tier entities like Instance, AvailabilityGroup etc.')]

	param(
        [Parameter(Mandatory=$false, HelpMessage='Subscription Id')]
        [System.String[]]
        ${SubscriptionId},

        [Parameter(Mandatory, HelpMessage='The name of the resource group where the recovery services vault is present')]
        [System.String]
        ${ResourceGroupName},

        [Parameter(Mandatory, HelpMessage='The name of the recovery services vault')]
        [System.String]
        ${VaultName},

        [Parameter(ParameterSetName="FilterParamSet", Mandatory=$true, HelpMessage='Specifies the DatasourceType')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName="FilterParamSet", Mandatory=$false, HelpMessage='Specifies a container object for which this cmdlet gets protectable items. To obtain an ProtectionContainerResource, use the Get-AzRecoveryServicesBackupContainer cmdlet')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionContainerResource]
        ${Container},

        [Parameter(ParameterSetName="IdParamSet", Mandatory=$true, HelpMessage='Specifies the ARM ID of an Instance or Availability Group')]
        [System.String]
        ${ParentID},

        [Parameter(ParameterSetName="FilterParamSet", Mandatory=$false, HelpMessage='Specifies the type of protectable item. Acceptable values: SQLDataBase, SQLInstance, SQLAvailabilityGroup')]
        [Parameter(ParameterSetName="IdParamSet", Mandatory=$false, HelpMessage='Specifies the type of protectable item. Acceptable values: SQLDataBase, SQLInstance, SQLAvailabilityGroup')]
        [ValidateSet("SQLDataBase", "SQLInstance", "SQLAvailabilityGroup", ErrorMessage = "Invalid value for ItemType. Please provide a valid item type. Valid values are 'SQLDataBase', 'SQLInstance' and 'SQLAvailabilityGroup'")]
        [System.String]
        ${ItemType},

        [Parameter(ParameterSetName="FilterParamSet", Mandatory=$false, HelpMessage="Specifies the name of the Database, Instance or AvailabilityGroup")]
        [Parameter(ParameterSetName="IdParamSet", Mandatory=$false, HelpMessage="Specifies the name of the Database, Instance or AvailabilityGroup")]        
        [System.String]
        ${Name},

        [Parameter(ParameterSetName="FilterParamSet", Mandatory=$false, HelpMessage="Specifies the name of the server to which the item belongs")]
        [Parameter(ParameterSetName="IdParamSet", Mandatory=$false, HelpMessage="Specifies the name of the server to which the item belongs")]        
        [System.String]
        ${ServerName},
                
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
        Write-Host "reached .... 1"
        
        # get DSType from policy
        $parameterSetName = $PsCmdlet.ParameterSetName
                
        # get protectable items filter
        $filter = $null
        if($parameterSetName -eq "IdParamSet"){
            $filter = Get-ProtectableItemFilter -ParentID $ParentID 
        }
        else{
            if($Container -ne $null){
                $filter = Get-ProtectableItemFilter -DatasourceType $DatasourceType -Container $Container
            }
            else {                
                $filter = Get-ProtectableItemFilter -DatasourceType $DatasourceType
            }
        }
        
        Write-Host "reached .... 2"
        Write-Host $filter

        $protectableItemsList = $null
        if($SubscriptionId -ne $null){

            $protectableItemsList = Az.RecoveryServices.Internal\Get-AzRecoveryServicesBackupProtectableItem -ResourceGroupName $ResourceGroupName -VaultName $VaultName -SubscriptionId $SubscriptionId -Filter $filter
        }
        else{
            $protectableItemsList = Az.RecoveryServices.Internal\Get-AzRecoveryServicesBackupProtectableItem -ResourceGroupName $ResourceGroupName -VaultName $VaultName -Filter $filter
        }

        Write-Host "reached .... 3"
                
        # Protectable item type filter
        # alternate - $protectableItemsList.Property.GetType().Name -match
        if($ItemType -ne ""){
            $protectableItemsList = $protectableItemsList | Where-Object { $_.ProtectableItemType -eq $ItemType }
        }

        # Name filter 
        if($Name -ne ""){
            $protectableItemsList = $protectableItemsList | Where-Object { $_.Name -eq $Name }
        }
        
        # ServerName filter 
        if($ServerName -ne ""){
            $protectableItemsList = $protectableItemsList | Where-Object { $_.Property.ServerName -eq $ServerName }
        }
        
        Write-Host "reached .... 4"

        # FetchNodesListAndAutoProtectionPolicy
        foreach($proItem in $protectableItemsList){

            Write-Host "reached .... 4 .... 1  $($proItem.Id)"

            $protectableItemURI = Get-ProtectableItemNameFromArmId -Id $proItem.Id

            Write-Host "reached .... 4 .... 1a  $protectableItemURI"

            $proItemType = ($protectableItemURI -split ";")[0]
            $itemName = ($protectableItemURI -split ";")[1]
            
            Write-Host "reached .... 4 .... 2"

            $containerUri = Get-ContainerNameFromArmId -Id $proItem.Id
                 
            Write-Host "reached .... 4 .... 3"
            Write-Host "reached .... 5"

            if($proItem.ProtectableItemType -ne "SQLDataBase"){
                    
                $backupManagementType = "AzureWorkload"
                $filter = Get-ProtectionIntentFilter -ItemType $proItemType -ItemName $itemName -ParentName $containerUri -BackupManagementType $backupManagementType
                
                # list protection intent
                $intentList = Get-AzRecoveryServicesBackupProtectionIntent -ResourceGroupName $ResourceGroupName -VaultName $VaultName -SubscriptionId $SubscriptionId -Filter $filter                    

                Write-Host "reached .... 5 .... 1"
                Write-Host "IntentList empty $($intentList -eq $null)"

                foreach($intent in $intentList){

                    # TODO: remove 
                    Write-Host "Intent .... "
                    Write-Host $intent.PolicyId

                    # type string
                    $proItem.AutoProtectionPolicy = $intent.PolicyId
                }
            }

            Write-Host "reached .... 6"
                
            if($proItem.ProtectableItemType -eq "SQLAvailabilityGroup"){
                try{
                    # get container 
                    $container = Get-AzRecoveryServicesProtectionContainer -ResourceGroupName $ResourceGroupName -VaultName $VaultName -SubscriptionId $SubscriptionId -FabricName "Azure" -ContainerName $containerUri

                    Write-Host "reached .... 6 .... 1"
                    Write-Host "Container empty $($container -eq $null)"

                    if($container -ne $null -and $container.Property.ExtendedInfo -ne $null){
                        
                        # TODO: remove
                        Write-Host "Container NodesList .... "
                        Write-Host $container.Property.ExtendedInfo.NodesList


                        # Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IDistributedNodesInfo[]
                        # 
                        $proItem.NodesList = $container.Property.ExtendedInfo.NodesList
                    }
                }
                catch{
                    Write-Debug "An error occurred: $($_.Exception.Message)"
                    # Write-Host "An error occurred: $($Error[0].Exception.Message)" -  TODO remove
                }

                Write-Host "reached .... 7"
            }            
        }

        Write-Host "reached .... 8"

        $protectableItemsList
    }
}