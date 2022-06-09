# Log In
Connect-AzAccount

# View current subscription
Get-AzContext

# Set subscription 
Get-AzSubscription
Set-AzContext -SubscriptionId "926771bb-5cdd-42a8-908b-04ef2a6d0343"

#$subscriptionID="926771bb-5cdd-42a8-908b-04ef2a6d0343"
#$hostpoolRG="rg-avd-004"

$RBACeerstelijnsUrl= "https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationEersteLijns.json"
$RBACtweedelijnsUrl= "https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationTweedeLijns.json"
$RBACderdelijnsUrl= "https://raw.githubusercontent.com/MarksMultiverse/AVD-RBAC/main/DesktopVirtualizationDerdeLijns.json"
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

# Create custom roles
New-AzRoleDefinition -InputFile  .\DesktopVirtualizationEersteLijns.json
New-AzRoleDefinition -InputFile  .\DesktopVirtualizationTweedeLijns.json
New-AzRoleDefinition -InputFile  .\DesktopVirtualizationDerdeLijns.json

# Connect to Azure AD
Connect-AzureAD

# Create Azure AD groups
New-AzureADGroup -DisplayName "AVD Eerste lijns PINK" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet" -Description "Security group for AVD Helpdesk"
New-AzureADGroup -DisplayName "AVD Tweede lijns PINK" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet" -Description "Security group for AVD Management"
New-AzureADGroup -DisplayName "AVD Derde lijns PINK" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet" -Description "Security group for AVD Admins"

# Setting object variables
$eerstelijnsid=Get-AzADGroup -DisplayName "AVD Eerste lijns PINK"
$tweedelijnsid=Get-AzADGroup -DisplayName "AVD Tweede lijns PINK"
$derdelijnsid=Get-AzADGroup -DisplayName "AVD Derde lijns PINK"

# Grant custom role definitions to the new groups
New-AzRoleAssignment -ObjectId $eerstelijnsid.id -RoleDefinitionName "Desktop Virtualization Eerste Lijns" -Scope "/subscriptions/$subscriptionID/resourceGroups/$hostpoolRG"
New-AzRoleAssignment -ObjectId $tweedelijnsid.id -RoleDefinitionName "Desktop Virtualization Tweede Lijns" -Scope "/subscriptions/$subscriptionID/resourceGroups/$hostpoolRG"
New-AzRoleAssignment -ObjectId $derdelijnsid.id -RoleDefinitionName "Desktop Virtualization Derde Lijns" -Scope "/subscriptions/$subscriptionID/resourceGroups/$hostpoolRG"
