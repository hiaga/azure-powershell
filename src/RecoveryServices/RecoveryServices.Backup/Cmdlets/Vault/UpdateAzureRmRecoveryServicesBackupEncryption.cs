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

using System;
using System.Linq;
using System.Management.Automation;
using Microsoft.Azure.Management.RecoveryServices.Backup.Models;
using Microsoft.Azure.Management.Internal.Resources.Utilities.Models;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.ServiceClientAdapterNS;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets.Models;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;
using Newtonsoft.Json;
using Microsoft.Azure.Management.RecoveryServices.Models;

namespace Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets
{
    /// <summary>
    /// Used to set RecoveryServices Vault properties
    /// </summary>
    [Cmdlet("Update", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "RecoveryServicesBackupEncryption", SupportsShouldProcess = true)]
    public class UpdateAzureRmRecoveryServicesBackupEncryption : RSBackupVaultCmdletBase
    {
        [Parameter(Mandatory = true, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Encryption.EncryptionKeyName)]
        [ValidateNotNullOrEmpty]
        public string EncryptionKeyName;

        [Parameter(Mandatory = true, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Encryption.EncryptionKeyVaultName)]
        [ValidateNotNullOrEmpty]
        public string EncryptionKeyVaultName;

        [Parameter(Mandatory = false, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Encryption.EncryptionKeyVersion)]
        [ValidateNotNullOrEmpty]
        public string EncryptionKeyVersion = "";

        [Parameter(Mandatory = true, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Encryption.KeyVaultSubscriptionId)]
        [ValidateNotNullOrEmpty]
        public string KeyVaultSubscriptionId;

        [Parameter(Mandatory = false, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Encryption.InfrastructureEncryption)]
        [ValidateNotNullOrEmpty]
        public SwitchParameter InfrastructureEncryption;

        public override void ExecuteCmdlet()
        {
            ExecutionBlock(() =>
            {
                try
                {
                    ResourceIdentifier resourceIdentifier = new ResourceIdentifier(VaultId);
                    string vaultName = resourceIdentifier.ResourceName;
                    string resourceGroupName = resourceIdentifier.ResourceGroupName;
                                        
                    BackupResourceEncryptionConfigResource vaultEncryptionSettings = ServiceClientAdapter.GetVaultEncryptionConfig(resourceGroupName, vaultName);

                    if (EncryptionKeyName != null)
                    {
                        string EncryptionKeyURI;
                        if (EncryptionKeyVersion != null)
                        {
                            EncryptionKeyURI = "https://" + EncryptionKeyVaultName + ".vault.azure.net/keys/" + EncryptionKeyName + "/" + EncryptionKeyVersion;
                        }
                        else
                        {
                            EncryptionKeyURI = "https://" + EncryptionKeyVaultName + ".vault.azure.net/keys/" + EncryptionKeyName;
                        }
                        
                        vaultEncryptionSettings.Properties.EncryptionAtRestType = "CustomerManaged";
                        vaultEncryptionSettings.Properties.KeyUri = EncryptionKeyURI;
                        if (InfrastructureEncryption.IsPresent)
                        {
                            vaultEncryptionSettings.Properties.InfrastructureEncryptionState = "Enabled";
                        }
                        vaultEncryptionSettings.Properties.SubscriptionId = KeyVaultSubscriptionId;
                        vaultEncryptionSettings.Properties.LastUpdateStatus = null;                        
                        var response = ServiceClientAdapter.UpdateVaultEncryptionConfig(resourceGroupName, vaultName, vaultEncryptionSettings);
                    }
                }
                catch (Exception exception)
                {
                    WriteExceptionError(exception);
                }
            }, ShouldProcess(VaultId, VerbsCommon.Set));
        }
    }
}
