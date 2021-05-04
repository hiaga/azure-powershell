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
using System.Management.Automation;
using Microsoft.Azure.Management.RecoveryServices.Models;
using Microsoft.Azure.Commands.RecoveryServices.Properties;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;
using System.Collections.Generic;

namespace Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets
{
    /// <summary>
    /// Used to Update MSI for RSVault
    /// </summary>
    [Cmdlet("Update", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "RecoveryServicesVault", SupportsShouldProcess = true), OutputType(typeof(ARSVault))]
    public class UpdateAzureRmRecoveryServicesVault : RecoveryServicesCmdletBase
    {
        #region parameters      

        /// <summary>
        /// Gets or sets the resource group name.
        /// </summary>
        [Parameter(Mandatory = true, Position = 1)]
        [ResourceGroupCompleter]
        [ValidateNotNullOrEmpty]
        public string ResourceGroupName { get; set; }

        /// <summary>
        /// Gets or sets the vault name.
        /// </summary>
        [Parameter(Mandatory = true, Position = 2)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        /// <summary>
        /// The MSI type assigned to Recovery Services Vault. Input 'None' if MSI has to be removed.
        /// </summary>
        [Parameter(Mandatory = true, ValueFromPipeline = false)] // , HelpMessage = ParamHelpMsgs.Common.IdentityType
        [ValidateNotNullOrEmpty]
        [ValidateSet("SystemAssigned", "None", "UserAssigned")]
        public MSIdentity IdentityType { get; set; }


        /// <summary>
        /// The UserAssigned Identity assigned to Recovery Services Vault. 
        /// </summary>
        [Parameter(Mandatory = false, ValueFromPipeline = false)]
        [ValidateNotNullOrEmpty]        
        public string IdentityId { get; set; }

        #endregion

        public override void ExecuteCmdlet()
        {
            if (ShouldProcess(Resources.VaultTarget, "set"))
            {
                try
                {   
                    IdentityData MSI = new IdentityData();
                    Vault vault = RecoveryServicesClient.GetVault(this.ResourceGroupName, this.Name);

                    if (IdentityType == MSIdentity.SystemAssigned)
                    {
                        // if the vault already contains UserAssigned Identity - then we pass both
                        if (vault.Identity.Type.ToLower().Contains("userassigned"))
                        {
                            MSI.Type = MSIdentity.SystemAssigned.ToString() + ", " + 
                                MSIdentity.UserAssigned.ToString();
                        }
                        else
                        {
                            MSI.Type = MSIdentity.SystemAssigned.ToString();
                        }
                    }
                    else if (IdentityType == MSIdentity.None)
                    {
                        MSI.Type = MSIdentity.None.ToString();
                    }
                    else if(IdentityType == MSIdentity.UserAssigned)
                    {
                        if(IdentityId == null)
                        {
                            throw new ArgumentException("IdentityId can't be null");
                        }
                        // if the vault already contains SystemAssigned Identity - then we pass both
                        if (vault.Identity.Type.ToLower().Contains("systemassigned"))
                        {
                            MSI.Type = MSIdentity.SystemAssigned.ToString() + ", " +
                                MSIdentity.UserAssigned.ToString();
                        }
                        else
                        {
                            MSI.Type = MSIdentity.UserAssigned.ToString();
                        }                        
                        MSI.UserAssignedIdentities = new Dictionary<string, UserIdentity>();
                        MSI.UserAssignedIdentities.Add(IdentityId, new UserIdentity());
                    }
                    PatchVault patchVault = new PatchVault();
                    patchVault.Identity = MSI;
                    vault = RecoveryServicesClient.UpdateRSVault(this.ResourceGroupName, this.Name, patchVault);
                                        
                    WriteObject(new ARSVault(vault));
                }
                catch (Exception exception)
                {
                    WriteExceptionError(exception);
                }
            }
        }
    }
}
