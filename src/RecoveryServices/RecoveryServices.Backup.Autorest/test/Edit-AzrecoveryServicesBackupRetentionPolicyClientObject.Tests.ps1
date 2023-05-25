if(($null -eq $TestName) -or ($TestName -contains 'Edit-AzrecoveryServicesBackupRetentionPolicyClientObject'))
{
  $loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
  if (-Not (Test-Path -Path $loadEnvPath)) {
      $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
  }
  . ($loadEnvPath)
  $TestRecordingFile = Join-Path $PSScriptRoot 'Edit-AzrecoveryServicesBackupRetentionPolicyClientObject.Recording.json'
  $currentPath = $PSScriptRoot
  while(-not $mockingPath) {
      $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
      $currentPath = Split-Path -Path $currentPath -Parent
  }
  . ($mockingPath | Select-Object -First 1).FullName
}

Describe 'Edit-AzrecoveryServicesBackupRetentionPolicyClientObject' {

    It 'Test_1' {
        $sub = $env.TestBackupPolicy.SubscriptionId
        $rgName = $env.TestBackupPolicy.ResourceGroupName
        $vaultName = $env.TestBackupPolicy.VaultName
        $newPolicyName = $env.TestBackupPolicy.NewPolicyName
        
        $DebugPreference = "Continue"
        Write-Debug  -Message $sub
        Write-Debug  -Message $rgName
        Write-Debug  -Message $vaultName
        Write-Debug  -Message $newPolicyName
        $DebugPreference = "SilentlyContinue"

        $pol1=Get-AzRecoveryServicesPolicyTemplate -DatasourceType AzureVM
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableDailyRetention 1 -DailyRetentionDurationInDays 56 -EnableWeeklyRetention 1 -WeeklyRetentionDurationInWeeks 34 -WeeklyRetentionDaysOfTheWeek Sunday -EnableMonthlyRetention 1 -MonthlyRetentionScheduleType Daily -MonthlyRetentionDurationInMonths 54 -MonthlyRetentionDaysOfTheMonth 1,2,3 -EnableYearlyRetention 1 -YearlyRetentionScheduleType Daily -YearlyRetentionDurationInYears 47 -YearlyRetentionMonthsOfTheYear March, April -YearlyRetentionDaysOfTheMonth 2,4,5
        New-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -Policy $pol1 -PolicyName $newPolicyName
        
        # this Policy should be there - then delete it and then this policy shouldn't be there
        $policy=Get-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -PolicyName $newPolicyName
        $policy.Name | Should be $newPolicyName

        Remove-AzRecoveryServicesBackupPolicy -PolicyName $newPolicyName -ResourceGroupName $rgName -VaultName $vaultName
        #$pol = Get-AzRecoveryServicesBackupPolicy -VaultName $vaultName -ResourceGroupName $rgName -PolicyName $newPolicyName
        #$pol | Should -Be "NotFound"
    }

    It 'Test_2' {
        #sWhen chedule run frequency is daily and monthly or yearly retention is weekly
        $sub = $env.TestBackupPolicy.SubscriptionId
        $rgName = $env.TestBackupPolicy.ResourceGroupName
        $vaultName = $env.TestBackupPolicy.VaultName
        $newPolicyName = $env.TestBackupPolicy.NewPolicyName
        
        $pol1 = Get-AzRecoveryServicesPolicyTemplate -DatasourceType AzureVM
        
        # update daily retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableDailyRetention $true -DailyRetentionDurationInDays 56

        # update weekly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableWeeklyRetention $true -WeeklyRetentionDurationInWeeks 34 -WeeklyRetentionDaysOfTheWeek Sunday,Monday

        # update monthly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableMonthlyRetention $true -MonthlyRetentionScheduleType Weekly -MonthlyRetentionDurationInMonths 36 -MonthlyRetentionDaysOfTheWeek "Monday","Tuesday" -MonthlyRetentionWeeksOfTheMonth Second, Fourth

        # update yearly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableYearlyRetention $true -YearlyRetentionScheduleType Weekly -YearlyRetentionDurationInYears 67 -YearlyRetentionMonthsOfTheYear May, June -YearlyRetentionDaysOfTheWeek Monday, Tuesday -YearlyRetentionWeeksOfTheMonth First, Third
        
        # create new policy with modified retention policy
        New-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -Policy $pol1 -PolicyName $newPolicyName

        # this Policy should be there - then delete it and then this policy shouldn't be there
        $policy=Get-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -PolicyName $newPolicyName

        # verify policy modifications
        $policy.Name | Should be $newPolicyName
        $policy.Property.RetentionPolicy.DailySchedule.RetentionDuration.Count | Should be "56"
        $policy.Property.RetentionPolicy.WeeklySchedule.RetentionDuration.Count | Should be "34"
        $policy.Property.RetentionPolicy.WeeklySchedule.DaysOfTheWeek | Should be "Sunday","Monday"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionDuration.Count | Should be "36"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType | Should be "Weekly"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly[0].DaysOfTheWeek | Should be "Monday","Tuesday"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly[0].WeeksOfTheMonth | Should be "Second","Fourth"
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionDuration.Count | Should be "67"        
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType | Should be "Weekly"
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek | Should be "Monday","Tuesday"
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth | Should be "First","Third"
        $policy.Property.RetentionPolicy.YearlySchedule.MonthsOfYear | Should be "May","June"

        # remove policy
        Remove-AzRecoveryServicesBackupPolicy -PolicyName $newPolicyName -ResourceGroupName $rgName -VaultName $vaultName
        #$pol = Get-AzRecoveryServicesBackupPolicy -VaultName $vaultName -ResourceGroupName $rgName -PolicyName $newPolicyName
        #$pol | Should -Be "NotFound"
    }

        It 'Test_3' {
        #When schedule run frequency is daily and monthly or yearly retention is daily
        $sub = $env.TestBackupPolicy.SubscriptionId
        $rgName = $env.TestBackupPolicy.ResourceGroupName
        $vaultName = $env.TestBackupPolicy.VaultName
        $newPolicyName = $env.TestBackupPolicy.NewPolicyName
        
        $pol1 = Get-AzRecoveryServicesPolicyTemplate -DatasourceType AzureVM
        
        # update daily retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableDailyRetention $true -DailyRetentionDurationInDays 56

        # fetch or set the schedule run days using Edit-AzrecoveryServicesBackupSchedulePolicyClientObject command
        $pol1.SchedulePolicy.ScheduleRunDay="Monday", "Tuesday", "Wednesday"

        # update weekly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableWeeklyRetention $true -WeeklyRetentionDurationInWeeks 34 -WeeklyRetentionDaysOfTheWeek Sunday,Monday
        
        # set the schedule run days using Edit-AzrecoveryServicesBackupSchedulePolicyClientObject command
        $pol1.SchedulePolicy.ScheduleRunFrequency="Daily"
        
        # update monthly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableMonthlyRetention $true -MonthlyRetentionScheduleType Daily -MonthlyRetentionDurationInMonths 45 -MonthlyRetentionDaysOfTheMonth 1,6,28
        
        # update yearly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType AzureVM -EnableYearlyRetention $true -YearlyRetentionScheduleType Daily -YearlyRetentionMonthsOfTheYear May,April -YearlyRetentionDaysOfTheMonth @("1","2","3") -YearlyRetentionDurationInYears 43        
        
        # create new policy with modified retention policy
        New-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -Policy $pol1 -PolicyName $newPolicyName

        # this Policy should be there - then delete it and then this policy shouldn't be there
        $policy=Get-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -PolicyName $newPolicyName

        # verify policy modifications
        $policy.Name | Should be $newPolicyName
        $policy.Property.RetentionPolicy.DailySchedule.RetentionDuration.Count | Should be "56"
        $policy.Property.RetentionPolicy.WeeklySchedule.RetentionDuration.Count | Should be "34"
        $policy.Property.RetentionPolicy.WeeklySchedule.DaysOfTheWeek | Should be "Sunday","Monday"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionDuration.Count | Should be "45"
        $policy.Property.RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType | Should be "Daily"
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionDuration.Count | Should be "43"        
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionScheduleFormatType | Should be "Daily"
        $policy.Property.RetentionPolicy.YearlySchedule.MonthsOfYear | Should be "May","April"
        $policy.Property.RetentionPolicy.YearlySchedule.RetentionScheduleDaily.DaysOfTheMonth[-1].Date | Should be 3

        # remove policy
        Remove-AzRecoveryServicesBackupPolicy -PolicyName $newPolicyName -ResourceGroupName $rgName -VaultName $vaultName
        #$pol = Get-AzRecoveryServicesBackupPolicy -VaultName $vaultName -ResourceGroupName $rgName -PolicyName $newPolicyName
        #$pol | Should -Be "NotFound"
    }
        

    It 'Test_4' {
        #When schedule run frequency is weekly and monthly or yearly retention is weekly
        $sub = $env.TestBackupPolicy.SubscriptionId
        $rgName = $env.TestBackupPolicy.ResourceGroupName
        $vaultName = $env.TestBackupPolicy.VaultName
        $newPolicyName = $env.TestBackupPolicy.NewPolicyName
        
        $pol1=Get-AzRecoveryServicesPolicyTemplate -DatasourceType SAPHANA

        #set the schedule run frequency and schedule run days using Edit-AzrecoveryServicesBackupSchedulePolicyClientObject command
        $pol1.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunFrequency="Weekly"
        $pol1.SubProtectionPolicy[0].SchedulePolicy.ScheduleRunDay="Monday","Tuesday"

      
        # update weekly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType SAPHANA -ModifyFullBackup -EnableWeeklyRetention $true -WeeklyRetentionDurationInWeeks 11 -WeeklyRetentionDaysOfTheWeek Sunday
        
        # update monthly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType SAPHANA -ModifyFullBackup -EnableMonthlyRetention $true -MonthlyRetentionScheduleType Weekly -MonthlyRetentionDurationInMonths 34 -MonthlyRetentionDaysOfTheWeek Monday,Tuesday -MonthlyRetentionWeeksOfTheMonth First, Last

        # update yearly retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType SAPHANA -ModifyFullBackup -EnableYearlyRetention $true -YearlyRetentionScheduleType Weekly -YearlyRetentionDurationInYears 47 -YearlyRetentionMonthsOfTheYear May,June -YearlyRetentionDaysOfTheWeek Monday,Tuesday -YearlyRetentionWeeksOfTheMonth Last,First

        # update incremental/differential backup retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType SAPHANA -ModifyIncrementalBackup -IncrementalRetentionPeriodInDays 64

         # update log backup retention
        Edit-AzrecoveryServicesBackupRetentionPolicyClientObject -Policy $pol1 -DatasourceType SAPHANA -ModifyLogBackup -LogRetentionPeriodInDays 23 

        # create new policy with modified retention policy
        New-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -Policy $pol1 -PolicyName $newPolicyName

        # this Policy should be there - then delete it and then this policy shouldn't be there
        $policy=Get-AzRecoveryServicesBackupPolicy -ResourceGroupName $rgName -VaultName $vaultName -PolicyName $newPolicyName

        # verify policy modifications
        $policy.Name | Should be $newPolicyName
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.DailySchedule.RetentionDuration.Count | Should be $null
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.WeeklySchedule.RetentionDuration.Count | Should be "11"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.WeeklySchedule.DaysOfTheWeek | Should be "Monday","Tuesday"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionDuration.Count | Should be "34"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionScheduleFormatType | Should be "Weekly"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly[0].DaysOfTheWeek | Should be "Monday","Tuesday"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly[0].WeeksOfTheMonth | Should be "First","Last"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionDuration.Count | Should be "47"        
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionScheduleFormatType | Should be "Weekly"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek | Should be "Monday","Tuesday"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth | Should be "Last","First"
        $policy.Property.SubProtectionPolicy[0].RetentionPolicy.YearlySchedule.MonthsOfYear | Should be "May","June"
        $policy.Property.SubProtectionPolicy[1].RetentionPolicy.RetentionDurationCount | Should be "64"
        $policy.Property.SubProtectionPolicy[2].RetentionPolicy.RetentionDurationCount | Should be "23"

        # remove policy
        Remove-AzRecoveryServicesBackupPolicy -PolicyName $newPolicyName -ResourceGroupName $rgName -VaultName $vaultName
        #$pol = Get-AzRecoveryServicesBackupPolicy -VaultName $vaultName -ResourceGroupName $rgName -PolicyName $newPolicyName
        #$pol | Should -Be "NotFound"
    }
}