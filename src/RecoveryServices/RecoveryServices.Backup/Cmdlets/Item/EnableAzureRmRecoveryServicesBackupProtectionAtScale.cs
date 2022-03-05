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
using Microsoft.Azure.Commands.RecoveryServices.Backup.Helpers;
using Microsoft.Azure.Commands.RecoveryServices.Backup.Properties;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;
using Microsoft.Azure.Management.Internal.Resources.Utilities.Models;
using Microsoft.Azure.Management.RecoveryServices.Backup.Models;
using Microsoft.Rest.Azure.OData;
/*using Azure.Core;
using Azure.Identity;
using Azure.ResourceManager.Resources;
using Azure.ResourceManager.Resources.Models;*/
using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace Microsoft.Azure.Commands.RecoveryServices.Backup.Cmdlets
{
    /// <summary>
    /// Enable protection of an item with the recovery services vault. 
    /// Returns the corresponding job created in the service to track this operation.
    /// </summary>
    [Cmdlet("Enable", ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "RecoveryServicesBackupProtectionAtScale", SupportsShouldProcess = true), OutputType(typeof(Object))]
    public class EnableAzureRmRecoveryServicesBackupProtectionAtScale : RSBackupVaultCmdletBase
    {

        public override void ExecuteCmdlet()
        {
            ExecutionBlock(() =>
            {
                base.ExecuteCmdlet();

                ResourceIdentifier resourceIdentifier = new ResourceIdentifier(VaultId);
                string vaultName = resourceIdentifier.ResourceName;
                string resourceGroupName = resourceIdentifier.ResourceGroupName;

                Logger.Instance.WriteDebug("reched here .... 1");
                
                EnableProtectionAtScale(resourceGroupName,"EnableProtectionAtScalePowerShell");

                Logger.Instance.WriteDebug("reched here .... 2");
                WriteObject("success");
            });           
        }

        public void EnableProtectionAtScale(string resourceGroupName, string deploymentName) 
        {   
            // ServiceClientAdapter.DeployTemplate
            
            DeploymentHelper deploymentHelper = new DeploymentHelper();
            //deploymentHelper.Run();

            /*// Try to obtain the service credentials
            var serviceCreds = await ApplicationTokenProvider.LoginSilentAsync(tenantId, clientId, clientSecret);
*/
            // Read the template and parameter file contents
            JObject templateFileContents = deploymentHelper.GetJsonFileContents(deploymentHelper.pathToTemplateFile);
            JObject parameterFileContents = deploymentHelper.GetJsonFileContents(deploymentHelper.pathToParameterFile);

            // Create the resource manager client
            // var resourceManagementClient = new ResourceManagementClient(serviceCreds);
            // resourceManagementClient.SubscriptionId = subscriptionId;

            // Create or check that resource group exists ---------------------------------------------------------- uncomment this
            // EnsureResourceGroupExists(resourceManagementClient, resourceGroupName, resourceGroupLocation);  

            // Start a deployment
            ServiceClientAdapter.DeployTemplate(resourceGroupName, deploymentName, templateFileContents, parameterFileContents);
        }
    }
}
