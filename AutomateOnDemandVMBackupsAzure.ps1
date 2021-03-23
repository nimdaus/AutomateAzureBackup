<#
Originally written by: https://github.com/nimdaus
#>

Param (
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
    [String] $AzureSubscriptionId,
    [Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()]
    [String[]] $SpecificVaults,
    [Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()]
    [String[]] $SpecificVirtualMachines,
    [Parameter(Mandatory = $false)][ValidateNotNullOrEmpty()]
    [Int] $RetentionDays = 14
)

Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection

while(!($connectionResult) -and ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logging in to Azure...
    $connectionResult = Connect-AzAccount `
                            -ServicePrincipal `
                            -Tenant $connection.TenantID `
                            -SubscriptionId $AzureSubscriptionId `
                            -ApplicationId $connection.ApplicationID `
                            -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

$vaults = Get-AzRecoveryServicesVault
$currentDate = Get-Date
$RetainTill = $currentDate.AddDays($RetentionDays)
Write-Output "These recovery points will be retained until $($RetainTill)"

if ($PSBoundParameters.ContainsKey('SpecificVaults') -eq $true) {
        foreach ($Vault in $SpecificVaults) {
            Write-Output "Working on Vault: $($Vault.Name)"
            $containers = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered" -VaultID $Vault.ID
            Write-Output "Found $($containers.Count) Backup Containers"

            ForEach ($container in $containers) {
                    Write-Output "Working on container: $($container.FriendlyName)"
                    $VirtualMachines = Get-AzRecoveryServicesBackupItem -WorkloadType "AzureVM" -Container $container -VaultID $Vault.ID
                    Write-Output "Found + $($VirtualMachines.Count) Systems with Backup"

                    ForEach($VirtualMachine in $VirtualMachines) {
                        Write-Output "Working on Virtual Machine: $($VirtualMachine.FriendlyName)"
                        Backup-AzRecoveryServicesBackupItem -Item $VirtualMachine -ExpiryDateTimeUTC $RetainTill -VaultID $Vault.ID 
                        }
                    Write-Output ("")
            }
        $Joblist = Get-AzRecoveryServicesBackupJob -Status InProgress -VaultId $vault.ID -BackupManagementType AzureVM
        Write-Output "$Joblist"
        Write-Output ("")
        }
}

elseif ($PSBoundParameters.ContainsKey('SpecificVirtualMachines ') -eq $true) {
    foreach ($vault in $vaults) {
        Write-Output "Working on Vault: $($vault.Name)"
        $containers = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered"  -VaultID $Vault.ID
        Write-Output "Found $($containers.Count) Backup Containers"

        ForEach ($container in $containers) {
            Write-Output "Working on container: $($container.FriendlyName)"
            $VirtualMachines = Get-AzRecoveryServicesBackupItem -WorkloadType "AzureVM" -Container $container -VaultID $Vault.ID 
            Write-Output "Found $($VirtualMachines.Count) Systems with Backup"

            ForEach($VirtualMachine in $SpecificVirtualMachines) {
                Write-Output "Working on Virtual Machine: $($VirtualMachine.FriendlyName)"
                Backup-AzRecoveryServicesBackupItem -Item $VirtualMachine -ExpiryDateTimeUTC $RetainTill -VaultID $Vault.ID 
                }
            Write-Output ("")
        }
    $Joblist = Get-AzRecoveryServicesBackupJob -Status InProgress -VaultId $vault.ID -BackupManagementType AzureVM
    Write-Output "$Joblist"
    Write-Output ("")
    }
}

else {
    foreach ($vault in $vaults) {
        Write-Output "Working on Vault: $($vault.Name)"
        $containers = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered"  -VaultID $Vault.ID
        Write-Output "Found $($containers.Count) Backup Containers"

        ForEach ($container in $containers) {
            Write-Output "Working on container: $($container.FriendlyName)"
            $VirtualMachines = Get-AzRecoveryServicesBackupItem -WorkloadType "AzureVM" -Container $container -VaultID $Vault.ID 
            Write-Output "Found $($VirtualMachines.Count) Systems with Backup"

            ForEach($VirtualMachine in $VirtualMachines) {
                Write-Output "Working on Virtual Machine: $($VirtualMachine.FriendlyName)"
                Backup-AzRecoveryServicesBackupItem -Item $VirtualMachine -ExpiryDateTimeUTC $RetainTill -VaultID $Vault.ID 
                }
            Write-Output ("")
        }
    $Joblist = Get-AzRecoveryServicesBackupJob -Status InProgress -VaultId $vault.ID -BackupManagementType AzureVM
    Write-Output "$Joblist"
    Write-Output ("")
    }
}