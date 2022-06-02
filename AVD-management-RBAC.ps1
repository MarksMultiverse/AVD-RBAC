# Log In
Connect-AzAccount

# View current subscription
Get-AzContext

# Set subscription 
Get-AzSubscription
Set-AzContext -SubscriptionId "926771bb-5cdd-42a8-908b-04ef2a6d0343"

$subscriptionID=“926771bb-5cdd-42a8-908b-04ef2a6d0343”
$hostpoolRG="rg-avd-004"

$RBACeerstelijnsUrl=" https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationEersteLijns.json"
$RBACtweedelijnsUrl=" https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationTweedeLijns.json"
$RBACderdelijnsUrl=" https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationDerdeLijns.json"
$RBACeerstelijnsPath= "DesktopVirtualizationEersteLijns.json"
$RBACtweedelijnsPath= "DesktopVirtualizationTweedeLijns.json"
$RBACderdelijnsPath= "DesktopVirtualizationDerdeLijns.json"

# Download the file
Invoke-WebRequest -Uri $RBACeerstelijnsUrl -OutFile $RBACeerstelijnsPath -UseBasicParsing
Invoke-WebRequest -Uri $RBACtweedelijnsUrl -OutFile $RBACtweedelijnsPath -UseBasicParsing
Invoke-WebRequest -Uri $RBACderdelijnsUrl -OutFile $RBACderdelijnsPath -UseBasicParsing
# Update the file
((Get-Content -path $RBACeerstelijnsPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $RBACeerstelijnsPath
((Get-Content -path $RBACeerstelijnsPath -Raw) -replace '<rgName>', $hostpoolRG) | Set-Content -Path $RBACeerstelijnsPath
((Get-Content -path $RBACtweedelijnsPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $RBACtweedelijnsPath
((Get-Content -path $RBACtweedelijnsPath -Raw) -replace '<rgName>', $hostpoolRG) | Set-Content -Path $RBACtweedelijnsPath
((Get-Content -path $RBACderdelijnsPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $RBACderdelijnsPath
((Get-Content -path $RBACderdelijnsPath -Raw) -replace '<rgName>', $hostpoolRG) | Set-Content -Path $RBACderdelijnsPath

New-AzRoleDefinition -InputFile  .\DesktopVirtualizationEersteLijns.json
New-AzRoleDefinition -InputFile  .\DesktopVirtualizationTweedeLijns.json
New-AzRoleDefinition -InputFile  .\DesktopVirtualizationDerdeLijns.json