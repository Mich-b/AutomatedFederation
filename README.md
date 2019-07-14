# AutomatedFederation

## Prerequisites & set-up
-  Powershell 5.1 or higher (https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-2.4.0)
- .NET Framework 4.7.2 or later.

In a privileged powershell cmd window:
```
Install-Module -Name Az -AllowClobber
```

In a normal powershell cmd window:
```
Connect-AzAccount
```

## Run the template
### Set up Azure resource group
```
# get a list of locations
Get-AzLocation | format-table
# create a new resource group for your deployment
New-AzResourceGroup -Name AutomatedFederation -Location westeurope 
```
### Run the ARM templates 
1. Create the DC
```
New-AzResourceGroupDeployment -ResourceGroupName AutomatedFederation -TemplateUri https://raw.githubusercontent.com/Mich-b/AutomatedFederation/master/vm_dc_azuredeploy.json
```

2. Create a new VM and join the Domain
```
New-AzResourceGroupDeployment -ResourceGroupName AutomatedFederation -TemplateUri https://raw.githubusercontent.com/Mich-b/AutomatedFederation/master/vm_join_azuredeploy.json
```
3. Manually add the ADFS role (to be automated)


## Troubleshooting
- make sure the domain name contains more than 3 characters

## Update: better way
A better way may be to use the new powershell AZ cmdlets. However, these seem not to be documented very well yet. 
In progess at the moment. For now:
- AD setup using vm_dc_azuredeploy.json
- ADFS setup manually
- vm_dc.ps1 in progress to replace dc_azuredeploy.json
