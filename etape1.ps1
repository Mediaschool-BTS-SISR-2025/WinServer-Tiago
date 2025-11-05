# 1. Installation des rôles AD, DNS, DHCP
Write-Host "Installation des rôles AD DS, DNS et DHCP..." -f Yellow
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature -Name DNS -IncludeManagementTools
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# 2. Promotion en Contrôleur de Domaine (redémarrera le serveur)
Write-Host "Promotion du serveur en contrôleur de domaine..." -f Yellow
Install-ADDSForest -DomainName "mediaschool.local" -InstallDns -SafeModeAdministratorPassword (Read-Host -AsSecureString "Entrez un mot de passe pour le mode restauration")

# --- ATTENDEZ LE REDÉMARRAGE AVANT DE CONTINUER ---
# --- RE-OUVREZ POWERSHELL EN ADMIN DE DOMAINE (ex: MEDIASCHOOL\Administrateur) ---