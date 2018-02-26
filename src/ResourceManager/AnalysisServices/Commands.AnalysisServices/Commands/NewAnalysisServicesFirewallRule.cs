﻿// ----------------------------------------------------------------------------------
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
using System.Collections;
using System.Linq;
using System.Management.Automation;
using Microsoft.Azure.Commands.AnalysisServices.Models;
using Microsoft.Azure.Commands.AnalysisServices.Properties;
using Microsoft.Rest.Azure;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;

namespace Microsoft.Azure.Commands.AnalysisServices
{
    [Cmdlet(VerbsCommon.New, "AzureRmAnalysisServicesFirewallRule"), OutputType(typeof(AzureAnalysisServicesFirewallRule))]
    [Alias("New-AzureAsFWRule")]
    public class NewAnalysisServicesFirewallRule : AnalysisServicesCmdletBase
    {
        private readonly AzureAnalysisServicesFirewallRule _rule;

        [Parameter(ValueFromPipelineByPropertyName = true, Position = 0, Mandatory = true,
            HelpMessage = "Name of firewall rule")]
        [ResourceGroupCompleter()]
        [ValidateNotNullOrEmpty]
        public string FirewallRuleName
        {
            get { return _rule.FirewallRuleName; }
            set { _rule.FirewallRuleName = value; }
        }

        [Parameter(ValueFromPipelineByPropertyName = true, Position = 1, Mandatory = true,
            HelpMessage = "IP range start")]
        [ValidateNotNullOrEmpty]
        public string RangeStart
        {
            get { return _rule.RangeStart; }
            set { _rule.RangeStart = value; }
        }

        [Parameter(ValueFromPipelineByPropertyName = true, Position = 2, Mandatory = true,
            HelpMessage = "IP range end")]
        [ValidateNotNullOrEmpty]
        public string RangeEnd
        {
            get { return _rule.RangeEnd; }
            set { _rule.RangeEnd = value; }
        }

        public NewAnalysisServicesFirewallRule ()
        {
            _rule = new AzureAnalysisServicesFirewallRule();
        }

        public override void ExecuteCmdlet()
        {
            WriteObject(_rule);
        }
    }
}