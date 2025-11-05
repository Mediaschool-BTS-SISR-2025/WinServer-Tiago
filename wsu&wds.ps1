# 14. Création des GPO pour WSUS [cite: 179]
Write-Host "Création des GPO pour WSUS..." -f Yellow
New-GPO -Name "GPO-WSUS-Pilote"
New-GPO -Name "GPO-WSUS-Production"

# 15. Configuration GPO-WSUS-Pilote
$gpoName = "GPO-WSUS-Pilote"
[cite_start]$wsusURL = "http://SRV-FS1:8530" # [cite: 181]
[cite_start]$targetGroup = "WSUS-Pilote" # [cite: 184]
$regPathWU = "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate"
$regPathAU = "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"

# Spécifier le serveur WSUS [cite: 181]
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathWU -ValueName "WUServer" -Value $wsusURL -Type String
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathWU -ValueName "WUStatusServer" -Value $wsusURL -Type String
# Activer le ciblage côté client [cite: 184]
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathWU -ValueName "TargetGroupEnabled" -Value 1 -Type DWord
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathWU -ValueName "TargetGroup" -Value $targetGroup -Type String
# Configurer Mises à jour auto (Mode 4) [cite: 182]
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathAU -ValueName "AUOptions" -Value 4 -Type DWord
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathAU -ValueName "ScheduledInstallDay" -Value 0 -Type DWord
Set-GPRegistryValue -Name $gpoName -Context Computer -Key $regPathAU -ValueName "ScheduledInstallTime" -Value 12 -Type DWord

# (Répétez pour "GPO-WSUS-Production" en changeant $gpoName et $targetGroup)

# 16. Liaison des GPO WSUS aux OU des Ordinateurs
New-GPLink -Name "GPO-WSUS-Pilote" -Target "OU=Pilotes,OU=Comptes-Ordinateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-GPLink -Name "GPO-WSUS-Production" -Target "OU=Production,OU=Comptes-Ordinateurs,OU=ECOLE,DC=mediaschool,DC=local"

# 17. Configuration des Options DHCP pour WDS (PXE) [cite: 205-207]
Write-Host "Configuration des options DHCP pour le PXE..." -f Yellow
$scopeId = "192.168.100.0"
Set-DhcpServerv4OptionValue -ScopeId $scopeId -OptionId 66 -Value "SRV-FS1.mediaschool.local"
Set-DhcpServerv4OptionValue -ScopeId $scopeId -OptionId 67 -Value '\Boot\x64\wdsmgfw.efi' # UEFI
# Set-DhcpServerv4OptionValue -ScopeId $scopeId -OptionId 67 -Value '\Boot\x64\wdsnbp.com' # BIOS Legacy