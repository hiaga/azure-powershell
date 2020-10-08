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
    /// Used to Update MSI for RSVault
    /// </summary>
    [Cmdlet("Add", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "RecoveryServicesVaultIdentity", SupportsShouldProcess = true), OutputType(typeof(Vault))]
    public class AddAzureRmRecoveryServicesVaultIdentity : RSBackupVaultCmdletBase
    {
        [Parameter(Mandatory = true, ValueFromPipeline = false, HelpMessage = ParamHelpMsgs.Common.IdentityType)]
        [ValidateNotNullOrEmpty]
        [ValidateSet("SystemAssigned")]
        public MSIdentity IdentityType { get; set; }

        public override void ExecuteCmdlet()
        {
            ExecutionBlock(() =>
            {
                try
                {
                    ResourceIdentifier resourceIdentifier = new ResourceIdentifier(VaultId);
                    string vaultName = resourceIdentifier.ResourceName;
                    string resourceGroupName = resourceIdentifier.ResourceGroupName;
                                        
                    Vault vault = null;
                    if (IdentityType == MSIdentity.SystemAssigned)
                    {                    
                        IdentityData MSI = new IdentityData();
                        MSI.Type = MSIdentity.SystemAssigned.ToString();

                        PatchVault patchVault = new PatchVault();
                        patchVault.Identity = MSI;
                        vault = ServiceClientAdapter.UpdateRSVault(resourceGroupName, vaultName, patchVault);                    
                    }                    
                    WriteObject(vault);
                }
                catch (Exception exception)
                {
                    WriteExceptionError(exception);
                }
            }, ShouldProcess(VaultId, VerbsCommon.Set));
        }
    }
}
