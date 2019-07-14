$LocationName = "westeurope"
$ResourceGroupName = Read-Host 'What is the resource group you want to deploy to'
$ComputerName = Read-Host 'What is the name of the vm you wish to create'
$VMName = $ComputerName
$VMSize = "Standard_DS3"

$NetworkName = "demonetwork"
$NICName = "adNic"
$SubnetName = "internalSubnet"
$SubnetAddressPrefix = "10.0.0.0/24"
$VnetAddressPrefix = "10.0.0.0/16"

## network security groups
$rdpRule = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 
$networkSecurityGroup = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $LocationName -Name "NSG-internal" -SecurityRules $rdpRule # multiple rules possible by comma separating them
## subnet
$SubnetInternal = New-AzVirtualNetworkSubnetConfig -NetworkSecurityGroup $networkSecurityGroup -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
## vnet
$Vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $SubnetInternal
## create public ip
$pip = New-AzPublicIpAddress -Name ($VMName+"pip") -ResourceGroupName $ResourceGroupName -Location $LocationName -Sku "Standard" -IdleTimeoutInMinutes 4 -AllocationMethod "static"

$IPconfigPriv = New-AzNetworkInterfaceIpConfig -Name "IPConfigPriv" -PrivateIpAddressVersion IPv4 -PrivateIpAddress "10.0.0.4" -Subnet $SubnetInternal -Primary
$IPConfigPub = New-AzNetworkInterfaceIpConfig -Name "IPConfigPub" -Subnet $SubnetInternal -PublicIpAddress $pip

#Create NIC
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -IpConfiguration $IPConfigPriv,$IPConfigPub

$Credential = Get-Credential

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose