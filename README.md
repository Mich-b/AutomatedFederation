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
```
# get a list of locations
Get-AzLocation | format-table
# create a new resource group for your deployment
New-AzResourceGroup -Name AutomatedFederation -Location westeurope 

New-AzResourceGroupDeployment -ResourceGroupName AutomatedFederation -TemplateUri https://raw.githubusercontent.com/Mich-b/AutomatedFederation/master/vm_dc_azuredeploy.json
```

## Troubleshooting
- make sure the domain name contains more than 3 characters