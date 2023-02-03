$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'BlobHardeningScenario.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'BlobHardeningScenario' {
    It 'ConfigureBackup' {
        $subId = $env.TestBlobHardeningScenario.SubscriptionId
        $location = $env.TestBlobHardeningScenario.Location
        $resourceGroupName = $env.TestBlobHardeningScenario.ResourceGroupName
        $vaultName = $env.TestBlobHardeningScenario.VaultName
        $policyName = $env.TestBlobHardeningScenario.PolicyName
        $storageAcountName = $env.TestBlobHardeningScenario.StorageAccountName


    }

    It 'TriggerBackupAndRestore' -skip {
        { throw [System.NotImplementedException] } | Should -Not -Throw
    }
}
