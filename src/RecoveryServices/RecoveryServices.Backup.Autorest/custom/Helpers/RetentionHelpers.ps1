
function ValidateDaysOfTheWeek {
	[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
	param(
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatasourceType,

		[Parameter(Mandatory=$false)]
        [string[]]
        ${WeeklyRetentionDaysOfTheWeek},   

        [Parameter(Mandatory=$false)]
        [string[]]
        ${MonthlyRetentionDaysOfTheWeek},
        
        [Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionDaysOfTheWeek} 

	)

	process
	{
        Write-Debug "Validating Days of the week Options"
        Write-Debug -Message $DatasourceType
        Write-Debug -Message ($WeeklyRetentionDaysOfTheWeek -join ', ')
        Write-Debug -Message ($MonthlyRetentionDaysOfTheWeek -join ', ')
        Write-Debug -Message ($YearlyRetentionDaysOfTheWeek -join ', ')

        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
        $allowedValues = [System.String]::Join(', ', $manifest.allowedDaysOfTheWeek)

        foreach ($day in $WeeklyRetentionDaysOfTheWeek) 
        {
            if ($day -notin $manifest.allowedDaysOfTheWeek) 
            {
                $errormsg = "Specified WeekDay is not supported: $day. Allowed values are: $allowedValues"
                throw $errormsg
            }
        }

        foreach ($day in $MonthlyRetentionDaysOfTheWeek) {
            if ($day -notin $manifest.allowedDaysOfTheWeek) {
                $errormsg = "Specified WeekDay is not supported: $day. Allowed values are: $allowedValues"
                throw $errormsg
            }
        }

        foreach ($day in $YearlyRetentionDaysOfTheWeek) 
        {
            if ($day -notin $manifest.allowedDaysOfTheWeek) 
            {
                $errormsg = "Specified WeekDay is not supported: $day. Allowed values are: $allowedValues"
                throw $errormsg
            }
        }  
	}
}

function ValidateMonthsOfTheYear {
	[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
	param(
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatasourceType,

		[Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionMonthsOfTheYear}

	)

	process
	{
        Write-Debug "Validating Months of the year Options"
        Write-Debug -Message $DatasourceType
        Write-Debug -Message ($YearlyRetentionMonthsOfTheYear -join ', ')
        

        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
        $allowedValues = [System.String]::Join(', ', $manifest.allowedMonthsOfTheYear)

        foreach ($month in $YearlyRetentionMonthsOfTheYear) 
        {
            if ($month -notin $manifest.allowedMonthsOfTheYear) 
            {
                $errormsg = "Specified month is not supported: $month. Allowed values are: $allowedValues"
                throw $errormsg
            }
        }
        
	}
}

function ValidateWeeksOfTheMonth {
	[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
	param(
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DatasourceType,

        [Parameter(Mandatory=$false)]
        [string[]]
        ${MonthlyRetentionWeeksOfTheMonth},

		[Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionWeeksOfTheMonth}

	)

	process
	{
        Write-Debug "Validating Months of the year Options"
        Write-Debug -Message $DatasourceType
        Write-Debug -Message ($MonthlyRetentionWeeksOfTheMonth -join ', ')
        Write-Debug -Message ($YearlyRetentionWeeksOfTheMonth -join ', ')
        

        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
        $allowedValues = [System.String]::Join(', ', $manifest.allowedWeeksOfTheMonth)

        foreach ($week in $MonthlyRetentionWeeksOfTheMonth) {
            if ($week -notin $manifest.allowedWeeksOfTheMonth) {
                $errormsg = "Specified weekOfMonth is not supported: $week. Allowed values are: $allowedValues"
                throw $errormsg
            }
        }

        foreach ($week in $YearlyRetentionWeeksOfTheMonth) {
            if ($week -notin $manifest.allowedWeeksOfTheMonth) {
                $errormsg = "Specified weekOfMonth is not supported: $week. Allowed values are: $allowedValues"
                throw $errormsg
            }
        } 
	}
}

# which parameter can be used under which other params
function ValidateRetentionParameters {                                                              
	[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
    param (
        [Parameter(Mandatory=$true)]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicy]
        $Policy,
        
        [Parameter(Mandatory=$true)]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        $DatasourceType,
        
        [Parameter(Mandatory=$true)]
        [hashtable]
        $parametersToTest
    )

	process
	{
        Write-Debug "Validating parameter combinations"
        Write-Debug -Message $DatasourceType
        
        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
        if($manifest.allowedSubProtectionPolicyTypes.Count -gt 1)
        {
            if(-not($ModifyFullBackup -or $ModifyDifferentialBackup -or $ModifyIncrementalBackup -or $ModifyLogBackup) )
            {
                $errormsg="Retention policy for SAPHANA/MSSQL workloads can only be modified on switching to ModifyFullBackup/ModifyDifferentialBackup/ModifyIncrementalBackup/ModifyLogBackup"
                throw $errormsg
            }
        }
        $Index=1
       
        if($ModifyFullBackup)
        {
            $FullBackupPolicy =  $Policy.SubProtectionPolicy | where { $_.PolicyType -match "Full" }
            $Index = $Policy.SubProtectionPolicy.IndexOf($FullBackupPolicy)
        }

        # Validate Daily Retention Parameters

		if ($DailyRetentionDurationInDays -ne $null) 
        { 
            $parametersEntered = [System.Collections.ArrayList]::new()
			if ($DailyRetentionDurationInDays -ne $null) 
            { 
				$parametersEntered.Add("DailyRetentionDurationInDays")
			}
            if ($EnableDailyRetention -ne $true) 
            { 
				$errormsg = $parametersEntered + " can only be used when Daily retention is enabled"
				throw $errormsg
			}
		}
        # Validate Weekly Retention Parameters
        
        if ($WeeklyRetentionDurationInWeeks -or $WeeklyRetentionDaysOfTheWeek) 
        {
			$parametersEntered = [System.Collections.ArrayList]::new()
			if ($WeeklyRetentionDurationInWeeks) 
            {
				$parametersEntered.Add("WeeklyRetentionDurationInWeeks")
			}
            if ($WeeklyRetentionDaysOfTheWeek) 
            {
				$parametersEntered.Add("WeeklyRetentionDaysOfTheWeek")
			}
            if ($EnableWeeklyRetention -ne $true) 
            {
				$errormsg = $parametersEntered + " can only be used when Weekly retention is enabled"
				throw $errormsg
			}
		}

        # Validate Monthly Retention Parameters
        if($MonthlyRetentionScheduleType -or $MonthlyRetentionDurationInMonths -or $MonthlyRetentionDaysOfTheWeek -or $MonthlyRetentionWeeksOfTheMonth -or $MonthlyRetentionDaysOfTheMonth ) 
        {
            $parametersEntered = [System.Collections.ArrayList]::new()
			if ($MonthlyRetentionScheduleType) 
            {
				$parametersEntered.Add("MonthlyRetentionScheduleType")
			}
            if ($MonthlyRetentionDurationInMonths) 
            {
				$parametersEntered.Add("MonthlyRetentionDurationInMonths")
			}
            if ($EnableMonthlyRetention -ne $true) 
            {
				$errormsg = $parametersEntered + " can only be used when Monthly retention is enabled"
				throw $errormsg
			}
            if($MonthlyRetentionScheduleType -ne "")
            {
                if($DatasourceType -eq "AzureVM")
                {
                    $Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType=$MonthlyRetentionScheduleType
                }
                else
                {
                    if(-not($ModifyFullBackup))
                    {
                        $errormsg="Monthly retention policy for SAPHANA/MSSQL workloads can only be modified on switching to ModifyFullBackup"
                        throw $errormsg
                    }                    
                    $Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType=$MonthlyRetentionScheduleType
                }
            }
            if(($MonthlyRetentionScheduleType -eq "Weekly") -or ($DataSourceType -eq "AzureVM" -and $Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Weekly") -or ((($DatasourceType -eq "SAPHANA") -or ($DatasourceType -eq "MSSQL")) -and ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Weekly")))
            {
                $parametersEntered = [System.Collections.ArrayList]::new()
                if ($MonthlyRetentionDaysOfTheMonth) 
                {
			    	$parametersEntered.Add("MonthlyRetentionDaysOfTheMonth")
                    $errormsg = $parametersEntered + " can only be used when day based Monthly retention is enabled"
			    	throw $errormsg
			    }
                if ($MonthlyRetentionIsLastDayIncluded)
                {
                    $parametersEntered.Add("MonthlyRetentionIsLastDayIncluded")
                    $errormsg = $parametersEntered + " can only be used when day based Monthly retention is enabled"
			    	throw $errormsg
                }
                if ($EnableMonthlyRetention -ne $true) 
                {
			    	$errormsg = $parametersEntered + " can only be used when day based Monthly retention is enabled"
			    	throw $errormsg
			    }  
            }
            elseif( ($MonthlyRetentionScheduleType -eq "Daily") -or ($DataSourceType -eq "AzureVM" -and $Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Daily") -or ((($DatasourceType -eq "SAPHANA") -or ($DatasourceType -eq "MSSQL")) -and ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Daily")))
            {
                $parametersEntered = [System.Collections.ArrayList]::new()
                if ($MonthlyRetentionDaysOfTheWeek) 
                {
			    	$parametersEntered.Add("MonthlyRetentionDaysOfTheWeek")
                    $errormsg = $parametersEntered + " can only be used when week based Monthly retention is enabled"
			    	throw $errormsg
			    }
                if ($MonthlyRetentionWeeksOfTheMonth)
                {
                    $parametersEntered.Add("MonthlyRetentionWeeksOfTheMonth")
                    $errormsg = $parametersEntered + " can only be used when week based Monthly retention is enabled"
			    	throw $errormsg
                }
                if ($EnableMonthlyRetention -ne $true ) 
                {
			    	$errormsg = $parametersEntered + " can only be used when week based Monthly retention is enabled"
			    	throw $errormsg
			    }
            }
            else
            {
                $errormsg= "Please specify Retention Schedule format type for monthly retention: weekly/daily"
                throw $errormsg
            }
        }
        
        # Validate Yearly Retention Parameters
        
        if( $YearlyRetentionScheduleType -or $YearlyRetentionDurationInYears -or $YearlyRetentionMonthsOfTheYear -or $YearlyRetentionDaysOfTheWeek -or $YearlyRetentionWeeksOfTheMonth -or $YearlyRetentionDaysOfTheMonth -or $YearlyRetentionIsLastDayIncluded) 
        {
            $parametersEntered = [System.Collections.ArrayList]::new()
			if ($YearlyRetentionScheduleType) 
            {
				$parametersEntered.Add("YearlyRetentionScheduleType")
			}
            if ($YearlyRetentionDurationInYears) 
            {
				$parametersEntered.Add("YearlyRetentionDurationInYears")
			}
            if ($YearlyRetentionMonthsOfTheYear) 
            {
				$parametersEntered.Add("YearlyRetentionMonthsOfTheYear")
			}
            if ($EnableYearlyRetention -ne $true) 
            {
				$errormsg = $parametersEntered + " can only be used when Yearly retention is enabled"
				throw $errormsg
			}
            if($YearlyRetentionScheduleType -ne "")
            {
                if($DatasourceType -eq "AzureVM")
                {
                    $Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType = $YearlyRetentionScheduleType
                }
                else
                {
                    if(-not($ModifyFullBackup))
                    {
                        $errormsg="Yearly retention policy for SAPHANA/MSSQL workloads can only be modified on switching to ModifyFullBackup"
                        throw $errormsg
                    }
         
                    $Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType = $YearlyRetentionScheduleType
                }
                
            }
            if( ($YearlyRetentionScheduleType -eq "Weekly") -or ($DataSourceType -eq "AzureVM" -and $Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Weekly" ) -or ((($DatasourceType -eq "SAPHANA") -or ($DatasourceType -eq "MSSQL")) -and ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Weekly")))
            {
                $parametersEntered = [System.Collections.ArrayList]::new()
                if ($YearlyRetentionDaysOfTheMonth) 
                {
			    	$parametersEntered.Add("YearlyRetentionDaysOfTheMonth")
                    $errormsg = $parametersEntered + " can only be used when day based Yearly retention is enabled"
			    	throw $errormsg
			    }
                if ($YearlyRetentionIsLastDayIncluded)
                {
                    $parametersEntered.Add("YearlyRetentionIsLastDayIncluded")
                    $errormsg = $parametersEntered + " can only be used when day based Yearly retention is enabled"
			    	throw $errormsg
                }
			    if ($EnableYearlyRetention -ne $true) 
                {
			    	$errormsg = $parametersEntered + " can only be used when day based Yearly retention is enabled"
			    	throw $errormsg
			    }                
            }
            elseif(($YearlyRetentionScheduleType -eq "Daily") -or ($DataSourceType -eq "AzureVM" -and $Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Daily") -or ((($DatasourceType -eq "SAPHANA") -or ($DatasourceType -eq "MSSQL")) -and ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Daily")))
            {
                $parametersEntered = [System.Collections.ArrayList]::new()
                if ($YearlyRetentionDaysOfTheWeek) 
                {
			    	$parametersEntered.Add("YearlyRetentionDaysOfTheWeek")
                    $errormsg = $parametersEntered + " can only be used when week based Yearly retention is enabled"
			    	throw $errormsg
			    }
                if ($YearlyRetentionWeeksOfTheMonth)
                {
                    $parametersEntered.Add("YearlyRetentionWeeksOfTheMonth")
                    $errormsg = $parametersEntered + " can only be used when week based Yearly retention is enabled"
			    	throw $errormsg
                }
                if ($EnableYearlyRetention -ne $true) 
                {
			    	$errormsg = $parametersEntered + " can only be used when week based Yearly retention is enabled"
			    	throw $errormsg
			    }               
            }
            else
            {
                $errormsg= "Please specify Retention Schedule format type for yearly retention: weekly/daily"
                throw $errormsg
            }
        }       
        
        if ($DifferentialRetentionPeriodInDays) 
        {
			$parametersEntered = [System.Collections.ArrayList]::new()
			if ($DifferentialRetentionPeriodInDays) 
            {
				$parametersEntered.Add("DifferentialRetentionPeriodInDays")
			}
            # check whether differential backup is supported for given DatasourceType
            $unsupportedParams = $parametersEntered | Where-Object { $param = $_; $param -notin $manifest.allowedDifferentialParams }
            if ($unsupportedParams.Count -gt 0) {
                $unsupportedParamsString = $unsupportedParams -join ', '
                $errormsg = " $DatasourceType 'dosen't support the following parameters:' $unsupportedParamsString"
                throw $errormsg
            }
            # check whether differential backup is enabled
            if(-not($ModifyDifferentialBackup))
            {
                $errormsg = $parametersEntered + " can only be used for modifying differential backup after switching to -ModifyDifferentialBackup"
				throw $errormsg
            }
		}
        
        if ($IncrementalRetentionPeriodInDays) 
        {
            $parametersEntered = [System.Collections.ArrayList]::new()
			if ($IncrementalRetentionPeriodInDays) 
            {
				$parametersEntered.Add("IncrementalRetentionPeriodInDays")
			}
            $unsupportedParams = $parametersEntered | Where-Object { $param = $_; $param -notin $manifest.allowedIncrementalParams }
            if ($unsupportedParams.Count -gt 0) {
                $unsupportedParamsString = $unsupportedParams -join ', '
                $errormsg = " $DatasourceType 'dosen't support the following parameters:' $unsupportedParamsString"
                throw $errormsg
            }
            if(-not($ModifyIncrementalBackup))
            {
                $errormsg = $parametersEntered + " can only be used for modifying incremental backup after switching to -ModifyIncrementalBackup"
				throw $errormsg
            }
        }

        if ( $LogRetentionPeriodInDays) 
        {
            $parametersEntered = [System.Collections.ArrayList]::new()
            
			if ($LogRetentionPeriodInDays) 
            {
				$parametersEntered.Add("LogRetentionPeriodInDays")
			}
            $unsupportedParams = $parametersEntered | Where-Object { $param = $_; $param -notin $manifest.allowedLogParams }
            if ($unsupportedParams.Count -gt 0) {
                $unsupportedParamsString = $unsupportedParams -join ', '
                $errormsg = " $DatasourceType 'dosen't support the following parameters:' $unsupportedParamsString"
                throw $errormsg
            }
            if(-not($ModifyLogBackup))
            {
                $errormsg = $parametersEntered + " can only be used after switching to -ModifyLogBackup "
				throw $errormsg
            }
        }
    }
}
        
 
function ValidateMandatoryFields {
	[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.DoNotExportAttribute()]
	param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IProtectionPolicy]
        $Policy,

		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},  

        [Parameter(Mandatory=$false)]
        [Nullable[Boolean]]
        ${EnableDailyRetention},
        
        [Parameter(Mandatory=$false)]
        [Nullable[Boolean]]
        ${EnableWeeklyRetention},
        
        [Parameter(Mandatory=$false)]
        [Nullable[Boolean]]
        ${EnableMonthlyRetention},
    
        [Parameter(Mandatory=$false)]
        [Nullable[Boolean]]
        ${EnableYearlyRetention},

        [Parameter(Mandatory=$false)]
        [Nullable[int]]
        ${DailyRetentionDurationInDays},

        [Parameter(Mandatory=$false)]
        [Nullable[int]]
        ${WeeklyRetentionDurationInWeeks},
    
        [Parameter(Mandatory=$false)]
        [string[]]
        ${WeeklyRetentionDaysOfTheWeek},      

        [Parameter(Mandatory=$false)]
        [Nullable[int]]
        ${MonthlyRetentionDurationInMonths},   

        [Parameter(Mandatory=$false)]
        [int[]]
        ${MonthlyRetentionDaysOfTheMonth},             

        [Parameter(Mandatory=$false)]
        [string[]]
        ${MonthlyRetentionDaysOfTheWeek},          
    
        [Parameter(Mandatory=$false)]
        [string[]]
        ${MonthlyRetentionWeeksOfTheMonth},        

        [Parameter(Mandatory=$false)]
        [Nullable[int]]
        ${YearlyRetentionDurationInYears},          

        [Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionMonthsOfTheYear},         

        [Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionDaysOfTheWeek},       

        [Parameter(Mandatory=$false)]
        [int[]]
        ${YearlyRetentionDaysOfTheMonth},       

        [Parameter(Mandatory=$false)]
        [string[]]
        ${YearlyRetentionWeeksOfTheMonth}      
	)

	process
	{
        Write-Debug "Validating mandatory parameters"
        Write-Debug -Message $DatasourceType
        
        $manifest = LoadManifest -DatasourceType $DatasourceType.ToString()
        
        $Index=1
        if($ModifyFullBackup)
        {
            $FullBackupPolicy =  $Policy.SubProtectionPolicy | where { $_.PolicyType -match "Full" }
            $Index = $Policy.SubProtectionPolicy.IndexOf($FullBackupPolicy)
        }

        # Validate Daily Retention Parameters

        if ($EnableDailyRetention -eq $true) 
        {
             if($manifest.allowedSubProtectionPolicyTypes.Count -gt 1)   #SAPHANA/MSSQL
			 {
                  if(($Policy.SubProtectionPolicy[$Index].RetentionPolicy.DailySchedule.RetentionDuration.Count -eq $null) -or ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.DailySchedule.RetentionDuration.Count -eq 0) ) 
                  {
			          $errormsg = "Daily retention duration in days must not be empty "
			          throw $errormsg
                  }
                  #Write-Host "Daily retention duration in days: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.DailySchedule.RetentionDuration.Count)"
			 }
             else    #AzureVM
             {
                 if(($Policy.RetentionPolicy.DailySchedule.RetentionDuration.Count -eq $null) -or ($Policy.RetentionPolicy.DailySchedule.RetentionDuration.Count -eq 0)) 
                 {
			         $errormsg = "Daily retention duration in days must not be empty "
			         throw $errormsg
                 }
                 #Write-Host "Daily retention duration in days: $($policy.RetentionPolicy.DailySchedule.RetentionDuration.Count)"
             }
		}

        # Validate Weekly Retention Parameters

        if ($EnableWeeklyRetention -eq $true) 
        {
             if($manifest.allowedSubProtectionPolicyTypes.Count -gt 1)   #SAPHANA/MSSQL
			 {
                  if(($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.DaysOfTheWeek.Count -eq 0) -or ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.DaysOfTheWeek.Count -eq $null) )
                  {
			          $errormsg = "Weekly retention days of the week must not be empty "
			          throw $errormsg
                  }
                  if(($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.RetentionDuration.Count -eq $null) -or ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.RetentionDuration.Count -eq 0)) 
                  {
			          $errormsg = "Weekly retention duration in weeks must not be empty "
			          throw $errormsg
                  }
                  #Write-Host "Weekly retention duration in weeks: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.RetentionDuration.Count)"
                  #Write-Host "Weekly retention days of the week: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.WeeklySchedule.DaysOfTheWeek)"
			 }
             else    #AzureVM
             {
                 if($Policy.RetentionPolicy.WeeklySchedule.DaysOfTheWeek.Count -eq 0) 
                 {
			         $errormsg = "Weekly retention days of the week must not be empty"
			         throw $errormsg
                 }
                 if($Policy.RetentionPolicy.WeeklySchedule.RetentionDuration.Count -eq ($null -or 0)) 
                 {
			          $errormsg = "Weekly retention duration in weeks must not be empty "
			          throw $errormsg
                 }
                 #Write-Host "Weekly retention duration in weeks: $($Policy.RetentionPolicy.WeeklySchedule.RetentionDuration.Count)"
                 #Write-Host "Weekly retention days of the week: $($Policy.RetentionPolicy.WeeklySchedule.DaysOfTheWeek)"
             }
		}
		
        # Validate Monthly Retention Parameters
        if ($EnableMonthlyRetention -eq $true) 
        { 
            if($manifest.allowedSubProtectionPolicyTypes.Count -gt 1)   #SAPHANA/MSSQL
			{
                if(($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionDuration[0].Count -eq $null) -or ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionDuration[0].Count -eq 0)) 
                {
			        $errormsg = "Monthly retention duration in months must not be empty "
			        throw $errormsg
                }
                if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Weekly")
                {
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek.Count -eq 0)
                    {
                        $errormsg = "Days of the week must not be empty for week based monthly retention."
				        throw $errormsg
                    }
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.weeksOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Weeks of the month must not be empty for week based monthly retention."
				        throw $errormsg
                    }
                    #Write-Host "Monthly retention duration in months: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionDuration.Count)"
                    #Write-Host "Monthly retention: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Monthly retention Days of the week: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek)"
                    #Write-Host "Monthly retention Weeks of the month: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.weeksOfTheMonth)"
                }
                elseif($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Daily")
                {
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleDaily.DaysOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Days of the month must not be empty for day based monthly retention."
				        throw $errormsg
                    }
                    #Write-Host "Monthly retention duration in months: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionDuration.Count)"
                    #Write-Host "Monthly retention: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType)"
                    #$days = $pol1.SubProtectionPolicy[$Index].RetentionPolicy.MonthlySchedule.RetentionScheduleDaily.DaysOfTheMonth
                    #Write-Host "Monthly retention Days of the month:"               
                    #foreach ($day in $days) {
                    #    $dayValue = $day.Date
                    #    Write-Host $dayValu$Index
                    #}
                }  
			}
            else    #AzureVM
            {
                if(($Policy.RetentionPolicy.MonthlySchedule.RetentionDuration.Count -eq $null) -or ($Policy.RetentionPolicy.MonthlySchedule.RetentionDuration.Count -eq 0 )) 
                {
			         $errormsg = "Monthly retention duration in months must not be empty "
			         throw $errormsg
                }
                if($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Weekly")
                {
                    if($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek.Count -eq 0)
                    {
                        $errormsg = "Days of the week must not be empty for week based monthly retention."
				        throw $errormsg
                    }
                    if($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.weeksOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Weeks of the month must not be empty for week based monthly retention."
				        throw $errormsg
                    }
                    #Write-Host "Monthly retention duration in months: $($Policy.RetentionPolicy.MonthlySchedule.RetentionDuration.Count)"
                    #Write-Host "Monthly retention: $($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Monthly retention Days of the week: $($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek)"
                    #Write-Host "Monthly retention Weeks of the month: $($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.weeksOfTheMonth)"
                }
                elseif($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType -eq "Daily")
                {
                    if($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleDaily.DaysOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Days of the month must not be empty for day based monthly retention."
				        throw $errormsg
                    }
                    #Write-Host "Monthly retention duration in months: $($Policy.RetentionPolicy.MonthlySchedule.RetentionDuration.Count)"
                    #Write-Host "Monthly retention: $($Policy.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType)"
                    #$days = $pol1.RetentionPolicy.MonthlySchedule.RetentionScheduleDaily.DaysOfTheMonth
                    #Write-Host "Monthly retention Days of the month:"               
                    #foreach ($day in $days) {
                    #    $dayValue = $day.Date
                    #    Write-Host $dayValue
                    #}
                }  
            }
		}

        # Validate Yearly Retention Parameters

        if ($EnableYearlyRetention -eq $true) 
        {
            if($manifest.allowedSubProtectionPolicyTypes.Count -gt 1)   #SAPHANA/MSSQL
			{
                if(($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionDuration.Count -eq $null) -or ($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionDuration.Count -eq 0)) 
                {
			        $errormsg = "Yearly retention duration in years must not be empty "
			        throw $errormsg
                }
                if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Weekly")
                {
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek.Count -eq 0)
                    {
                        $errormsg = "Days of the week must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.weeksOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Weeks of the month must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.monthsOfYear.Count -eq 0)
                    {
                        $errormsg = "Months of the year must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    #Write-Host "Yearly retention duration in years: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionDuration.Count)"
                    #Write-Host "Yearly retention: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Yearly retention Days of the week: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek)"
                    #Write-Host "Yearly retention Weeks of the month: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.weeksOfTheMonth)"
                    #Write-Host "Yearly retention Months of the year: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.monthsOfYear)"                    
                }
                elseif($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Daily")
                {
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.monthsOfYear.Count -eq 0)
                    {
                        $errormsg = "Months of the year must not be empty for day based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleDaily.DaysOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Days of the month must not be empty for day based Yearly retention."
				        throw $errormsg
                    }  
                    #Write-Host "Yearly retention duration in years: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionDuration.Count)"
                    #Write-Host "Yearly retention: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Yearly retention Months of the year: $($Policy.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.monthsOfYear)"
                    #$days = $pol1.SubProtectionPolicy[$Index].RetentionPolicy.YearlySchedule.RetentionScheduleDaily.DaysOfTheMonth
                    #Write-Host "Yearly retention Days of the month:"               
                    #foreach ($day in $days) {
                    #    $dayValue = $day.Date
                    #    Write-Host $dayValue
                    #}
                }  
			}
            else    #AzureVM
            {
                if(($Policy.RetentionPolicy.YearlySchedule.RetentionDuration.Count -eq $null) -or ($Policy.RetentionPolicy.YearlySchedule.RetentionDuration.Count -eq 0)) 
                {
			         $errormsg = "Yearly retention duration in years must not be empty "
			         throw $errormsg
                }
                if($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Weekly")
                {
                    if($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek.Count -eq 0)
                    {
                        $errormsg = "Days of the week must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.weeksOfTheMonth.Count -eq 0)
                    {
                        $errormsg = "Weeks of the month must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.RetentionPolicy.YearlySchedule.monthsOfYear.Count -eq 0)
                    {
                        $errormsg = "Months of the year must not be empty for week based Yearly retention."
				        throw $errormsg
                    }
                    #Write-Host "Yearly retention duration in years: $($Policy.RetentionPolicy.YearlySchedule.RetentionDuration.Count)"
                    #Write-Host "Yearly retention: $($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Yearly retention Days of the week: $($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek)"
                    #Write-Host "Yearly retention Weeks of the month: $($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.weeksOfTheMonth)"
                    #Write-Host "Yearly retention Months of the year: $($Policy.RetentionPolicy.YearlySchedule.monthsOfYear)"
                }
                elseif($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType -eq "Daily")
                {
                    if($Policy.RetentionPolicy.YearlySchedule.monthsOfYear.Count -eq 0)
                    {
                        $errormsg = "Months of the year must not be empty for day based Yearly retention."
				        throw $errormsg
                    }
                    if($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleDaily.DaysOfTheMonth.Count -eq 0 )
                    {
                        $errormsg = "Days of the month must not be empty for day based Yearly retention."
				        throw $errormsg
                    }
                    #Write-Host "Yearly retention duration in years: $($Policy.RetentionPolicy.YearlySchedule.RetentionDuration.Count)"
                    #Write-Host "Yearly retention: $($Policy.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType)"
                    #Write-Host "Yearly retention Months of the year: $($Policy.RetentionPolicy.YearlySchedule.monthsOfYear)"
                    #$days = $pol1.RetentionPolicy.YearlySchedule.RetentionScheduleDaily.DaysOfTheMonth
                    #Write-Host "Yearly retention Days of the month:"               
                    #foreach ($day in $days) {
                    #    $dayValue = $day.Date
                    #    Write-Host $dayValue
                    #}
                }  
            }
        }
    }
}