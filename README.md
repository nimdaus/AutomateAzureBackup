# Automate On-Demand backups for Azure Virtual Machines using PowerShell for Azure Backup

Automate On-Demand backups for Azure Virtual Machines using [Azure Powershell Documentation](https://docs.microsoft.com/en-us/powershell/azure/?view=azps-5.7.0)

## Features

Create additional recovery points beyond the automatic single day limitation of Azure Backup for Virtual Machines with up to 10 years of retention

## Step 1
Create an Automation Account with “Run As” account

## Step 2
Add Powershell Modules from Module Gallery (Under "Shared Resources") in Automation Account.

Import in the order given below:
1. Az.Accounts (used for auth)
2. Az.RecoveryServices
3. Az.Resources (used for tags)
4. Az.Automation (used for running other runbooks)
> Make sure to update modules using https://github.com/Microsoft/AzureAutomation-Account-Modules-Update

## Step 3
Create a PowerShell Runbook in the Automation Account.

## Step4
Past the powershell script directly into editor.
- Save the script
- Test the script using “Test Pane”
- Publish the Runbook

## Step 5
Schedule the Runbook for recurring runs

## Step 6
Pass the parameters required for the PowerShell Script;
> By default this automation will trigger backup of [ALL] Virtual Machines in [ALL] Vaults in [SPECIFIED] Subscription
* SubscriptionID
* Specific Vaults (CSV Array)
* Specific Virtual Machines (CSV Array)
* Retention (in Days)

## Additional Info
Monitor the success of the Runbook by selecting the Runbook, selecting "Resources" and finally selecting “Jobs”
