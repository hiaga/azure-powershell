// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.Models;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.ProviderModel;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.ServiceClientAdapterNS;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Helpers;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Properties;
using Microsoft.Azure.Management.Internal.Resources.Utilities.Models;
using ServiceClientModel = Microsoft.Azure.Management.RecoveryServices.Backup.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Management.Automation;
using Microsoft.Rest.Azure.OData;
using System;

namespace Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.Backup
{
    /// <summary>
    /// Disable protection of an item protected by the recovery services vault. 
    /// Returns the corresponding job created in the service to track this operation.
    /// </summary>
    [Cmdlet("Suspend", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "RecoveryServicesBackup", SupportsShouldProcess = true), OutputType(typeof(JobBase))]
    public class SuspendAzureRmRecoveryServicesBackup : RSBackupVaultCmdletBase
    {
        /// <summary>
        /// The protected item whose protection needs to be disabled.
        /// </summary>
        [Parameter(Position = 1, Mandatory = true, HelpMessage = ParamHelpMsgs.Item.SuspendItem,
            ValueFromPipeline = true)]
        [ValidateNotNullOrEmpty]
        public ItemBase Item { get; set; }
                
        [Parameter(Mandatory = false, HelpMessage = ParamHelpMsgs.Item.ForceSuspend)]
        public SwitchParameter Force { get; set; }
        
        public override void ExecuteCmdlet()
        {
            ExecutionBlock(() =>
            {
                ConfirmAction(
                    Force.IsPresent,
                    string.Format(Resources.DisableProtectionWarning, Item.Name), // CheckSB : modify this message
                    Resources.DisableProtectionMessage, // CheckSB : modify this message
                    Item.Name, () =>
                    {
                        base.ExecuteCmdlet();

                        ResourceIdentifier resourceIdentifier = new ResourceIdentifier(VaultId);
                        string vaultName = resourceIdentifier.ResourceName;
                        string resourceGroupName = resourceIdentifier.ResourceGroupName;
                        
                        PsBackupProviderManager providerManager =
                            new PsBackupProviderManager(new Dictionary<Enum, object>()
                            {
                                { VaultParams.VaultName, vaultName },
                                { VaultParams.ResourceGroupName, resourceGroupName },
                                { ItemParams.Item, Item },
                            }, ServiceClientAdapter);

                        IPsBackupProvider psBackupProvider =
                            providerManager.GetProviderInstance(Item.WorkloadType,
                            Item.BackupManagementType);

                        var itemResponse = psBackupProvider.SuspendBackup();
                        Logger.Instance.WriteDebug("Suspend backup response " + JsonConvert.SerializeObject(itemResponse));

                        // Track Response and display job details
                        HandleCreatedJob(
                                itemResponse,
                                Resources.DisableProtectionOperation, // CheckSB : modify this message
                                vaultName: vaultName,
                                resourceGroupName: resourceGroupName);

                    }
                );
            }, ShouldProcess(Item.Name, VerbsLifecycle.Disable));

        }
    }
}
