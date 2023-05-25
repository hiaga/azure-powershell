function Edit-AzRecoveryServicesBackupPolicyClientObject {
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicy')]
    [CmdletBinding(PositionalBinding=$false)]
    # RsvRef: should we call it workload type
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Edits the created default policy object.')]

	param (
        [Parameter(ParameterSetName='ModifySchedulePolicy', Mandatory, HelpMessage='Specifies the policy to be edited.')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicy]
        ${Policy},
        
        [Parameter(ParameterSetName='ModifySchedulePolicy', Mandatory, HelpMessage='Specifies the data source type.')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName='ModifySchedulePolicy', Mandatory, HelpMessage='Specifies whether the user needs to modify the schedule policy.')]
        [switch]
        ${SchedulePolicy},

        # Azure VM specific parameters

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the policy sub type for AzureVM.')]
        [ValidateSet("Standard", "Enhanced")]
        [string]
        ${PolicySubType},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the interval between backups in hours.')]
        #[ValidateSet(4,6,8,12)]
        [int]
        $Interval,

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the duration over which backup is taken in hours.')]
        #[ValidateSet(4,8,12,16,20,24)]
        [int]
        $ScheduleWindowDuration,

        # SAPHANA specific parameters
        
        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies whether the user needs to make a full backup.')]
        [switch]
        ${FullBackup},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies whether the user needs to make a log backup')]
        [switch]
        ${LogBackup},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the frequency of log backups in minutes')]
        #[ValidateSet(15,30,60,120,240,480,720,1440)]
        [int]
        $LogBackupFrequency,

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies whether the user needs to make a differential backup')]
        [switch]
        ${DifferentialBackup},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the days of the week for differential backup.')]
        #[ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [string[]]
        ${DifferentialRunDay},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the time at which differential backup must be taken.')]
        #[ValidatePattern("([^1-9]|1[0-2]):(00|30) (AM|PM)")]
        [string]
        ${DifferentialRunTime},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies whether the user needs to make a incremental backup')]
        [switch]
        ${IncrementalBackup},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the days of the week for incremental backup.')]
        #[ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [string[]]
        ${IncrementalRunDay},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the time at which incremental backup must be taken.')]
        #[ValidatePattern("([^1-9]|1[0-2]):(00|30) (AM|PM)")]
        [string]
        ${IncrementalRunTime},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the frequency of backup.')]
        [ValidateSet("Daily", "Weekly", "Hourly")]
        [string]
        ${BackupFrequency},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the days of the week for weekly backup.')]
        #[ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [string[]]
        ${ScheduleRunDay},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the time at which backup must be taken.')]
        #[ValidatePattern("([^1-9]|1[0-2]):(00|30) (AM|PM)")]
        [string]
        ${ScheduleTime},

        [Parameter(ParameterSetName='ModifySchedulePolicy', HelpMessage='Specifies the standard time zone.')]
        [string]
        ${TimeZone}
    )

    #validate {
    #    Write-Host "Validating parameters"
    #}

    process {

        #$policyJson = $Policy | ConvertTo-Json -Depth 10
        #Write-Host "Policy Details:"
        #Write-Host $policyJson

        
        if($Policy) {
			$policyObject = $Policy
		}

        # Get current date and time
        $currentDateTime = Get-Date

        # Parse user input as time
        $givenTime = [DateTime]::ParseExact($ScheduleTime, "h:mm tt", $null)

        #Write-Host "Given Time: $givenTime"
        #
        #Write-Host "Current Date Time: $currentDateTime"

        # Combine current date, given time, and UTC offset to form the desired format
        $convertedDateTime = [DateTime]::SpecifyKind(
            [DateTime]::new($currentDateTime.Year, $currentDateTime.Month, $currentDateTime.Day, $givenTime.Hour, $givenTime.Minute, $givenTime.Second),
            [System.DateTimeKind]::Utc
        )

        #Write-Host "Converted Date Time: $convertedDateTime"

        $policyJson = $policyObject | ConvertTo-Json -Depth 10
        Write-Host "Policy Details:"
        Write-Host $policyJson

        switch($DatasourceType) {
            "AzureVM" {

                $policyObject.PolicyType = ($PolicySubType -eq "Standard") ? "V1" : "V2"

                if ($SchedulePolicy) {

                    if ($PolicySubType -eq "Enhanced") {
                        $policyObject.SchedulePolicy = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SimpleSchedulePolicyV2]::new()
                    }

					switch($BackupFrequency) {
                        "Daily" {

                            if ($PolicySubType -eq "Enhanced") {
                                $policyObject.SchedulePolicy.DailyScheduleRunTime = @()
                                $policyObject.SchedulePolicy.DailyScheduleRunTime += $convertedDateTime

                                $policyObject.SchedulePolicy.Type = "SimpleSchedulePolicyV2"
                                $policyObject.SchedulePolicyType = "SimpleSchedulePolicyV2"
                            }
                            else {
							
                                $policyObject.SchedulePolicy.ScheduleRunTime[0] = $convertedDateTime
                            }

                            $policyObject.RetentionPolicy.DailySchedule.RetentionTime[0] = $convertedDateTime

                            $policyObject.SchedulePolicy.ScheduleRunFrequency = "Daily"

							$policyObject.TimeZone = $TimeZone

                            # Default values for testing
                            $policyObject.RetentionPolicy.WeeklySchedule = $null
                            $policyObject.RetentionPolicy.MonthlySchedule = $null
                            $policyObject.RetentionPolicy.YearlySchedule = $null
                        }

                        "Weekly" {

                            if ($PolicySubType -eq "Enhanced") {
                                $policyObject.SchedulePolicy.WeeklyScheduleRunDay = $ScheduleRunDay
                                $policyObject.SchedulePolicy.WeeklyScheduleRunTime = @()
                                $policyObject.SchedulePolicy.WeeklyScheduleRunTime += $convertedDateTime

                                $policyObject.SchedulePolicy.Type = "SimpleSchedulePolicyV2"
                                $policyObject.SchedulePolicyType = "SimpleSchedulePolicyV2"
                            }
                            else {
                                $policyObject.SchedulePolicy.ScheduleRunDay = $ScheduleRunDay
                                $policyObject.SchedulePolicy.ScheduleRunTime[0] = $convertedDateTime
                            }

                            $policyObject.SchedulePolicy.ScheduleRunFrequency = "Weekly"

                            $policyObject.RetentionPolicy.WeeklySchedule.DaysOfTheWeek = $ScheduleRunDay
                            $policyObject.RetentionPolicy.WeeklySchedule.RetentionTime[0] = $convertedDateTime

                            $policyObject.TimeZone = $TimeZone

                            $policyObject.InstantRpRetentionRangeInDay = 5

                            # Default values for testing
                            $policyObject.RetentionPolicy.DailySchedule = $null
                            $policyObject.RetentionPolicy.MonthlySchedule = $null
                            $policyObject.RetentionPolicy.YearlySchedule = $null
                        }

                        "Hourly" {
                            if ($PolicySubType -eq "Enhanced") {

                                $policyJson = $policyObject | ConvertTo-Json -Depth 10
                                Write-Host "Policy Details:"
                                Write-Host $policyJson

                                $policyObject.SchedulePolicy.ScheduleRunFrequency = "Hourly"
                                $policyObject.SchedulePolicy.HourlySchedule.Interval = $Interval
                                $policyObject.SchedulePolicy.HourlySchedule.ScheduleWindowDuration = $ScheduleWindowDuration
                                
                                $policyObject.SchedulePolicy.HourlySchedule.ScheduleWindowStartTime = $convertedDateTime
                                $policyObject.RetentionPolicy.DailySchedule.RetentionTime[0] = $convertedDateTime

                                $policyObject.TimeZone = $TimeZone

                                $policyObject.SchedulePolicy.Type = "SimpleSchedulePolicyV2"
                                $policyObject.SchedulePolicyType = "SimpleSchedulePolicyV2"

                                # Default values for testing
                                $policyObject.InstantRpRetentionRangeInDay = 7
                                $policyObject.RetentionPolicy.WeeklySchedule = $null
                                $policyObject.RetentionPolicy.MonthlySchedule = $null
								$policyObject.RetentionPolicy.YearlySchedule = $null
                            }
                            else {
                                Write-Host "Hourly backup is not supported for standard policy."
                            }
                        }
                    }
                }
            }
            
            "SAPHANA" {
                if ($SchedulePolicy) {
                    switch($BackupFrequency) {
				        "Daily" {
					        $policyObject.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunFrequency = "Daily"
                   
                            $policyObject.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.DailySchedule.RetentionTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.WeeklySchedule.RetentionTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionTime[0] = $convertedDateTime
                    
                            $policyObject.Setting.TimeZone = $TimeZone
				        }
				        
                        "Weekly" {
					        $policyObject.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunFrequency = "Weekly"
                    
                            $policyObject.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunDay = $ScheduleRunDay
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.WeeklySchedule.DaysOfTheWeek = $ScheduleRunDay

                            $policyObject.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.WeeklySchedule.RetentionTime[0] = $convertedDateTime
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionTime[0] = $convertedDateTime
                    
                            $policyObject.Setting.TimeZone = $TimeZone

                            # Default values for testing
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.DailySchedule = $null
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek[0] = $ScheduleRunDay[0]
                            $policyObject.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek[0] = $ScheduleRunDay[0]

                            
                            if($LogBackup) {
                                $policyObject.SubProtectionPolicy[1].SchedulePolicy.ScheduleFrequencyInMin = $LogBackupFrequency 
                            }

                            if($DifferentialBackup) {

                                $givenTime = [DateTime]::ParseExact($DifferentialRunTime, "h:mm tt", $null)
        
                                $convertedDateTime = [DateTime]::SpecifyKind(
                                    [DateTime]::new($currentDateTime.Year, $currentDateTime.Month, $currentDateTime.Day, $givenTime.Hour, $givenTime.Minute, $givenTime.Second),
                                    [System.DateTimeKind]::Utc
                                )

                                # Add a new sub protection policy for differential backup
                                $policyObject.SubProtectionPolicy += [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SubProtectionPolicy]::new()

                                $policyObject.SubProtectionPolicy[2].PolicyType = "Differential"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SimpleSchedulePolicy]::new()
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunFrequency = "Weekly"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunDay = $DifferentialRunDay
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunTime = $convertedDateTime
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.Type = "SimpleSchedulePolicy"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleWeeklyFrequency = 0

                                # Default values for testing
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SimpleRetentionPolicy]::new()
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.Type = "SimpleRetentionPolicy"
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.RetentionDurationCount = 30
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.RetentionDurationType = "Days"
                            }

                            if($IncrementalBackup) {

                                $givenTime = [DateTime]::ParseExact($IncrementalRunTime, "h:mm tt", $null)
        
                                $convertedDateTime = [DateTime]::SpecifyKind(
                                    [DateTime]::new($currentDateTime.Year, $currentDateTime.Month, $currentDateTime.Day, $givenTime.Hour, $givenTime.Minute, $givenTime.Second),
                                    [System.DateTimeKind]::Utc
                                )

                                # Add a new sub protection policy for differential backup
                                $policyObject.SubProtectionPolicy += [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SubProtectionPolicy]::new()

                                $policyObject.SubProtectionPolicy[2].PolicyType = "Incremental"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SimpleSchedulePolicy]::new()
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunFrequency = "Weekly"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunDay = $IncrementalRunDay
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleRunTime = $convertedDateTime
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.Type = "SimpleSchedulePolicy"
                                $policyObject.SubProtectionPolicy[2].SchedulePolicy.ScheduleWeeklyFrequency = 0

                                # Default values for testing
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SimpleRetentionPolicy]::new()
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.Type = "SimpleRetentionPolicy"
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.RetentionDurationCount = 30
                                $policyObject.SubProtectionPolicy[2].RetentionPolicy.RetentionDurationType = "Days"
                            }
                        }
                    }
                }
            }
        }

        # Return the modified $policyObject
        $policyObject
    }
}