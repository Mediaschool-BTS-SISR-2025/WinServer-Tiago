# 3. Création de la zone DNS inverse [cite: 45]
Write-Host "Création de la zone DNS inverse..." -f Yellow
Add-DnsServerPrimaryZone -NetworkID "192.168.100.0/24" -ReplicationScope "Forest"

# 4. Création des OU (Unités d'Organisation) [cite: 61, 62]
Write-Host "Création de la structure AD..." -f Yellow
New-ADOrganizationalUnit -Name "ECOLE" -Path "DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Comptes-Utilisateurs" -Path "OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Administration" -Path "OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Profs" -Path "OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Eleves" -Path "OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Comptes-Ordinateurs" -Path "OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Pilotes" -Path "OU=Comptes-Ordinateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADOrganizationalUnit -Name "Production" -Path "OU=Comptes-Ordinateurs,OU=ECOLE,DC=mediaschool,DC=local"

# 5. Création des Groupes de Sécurité [cite: 63, 64]
New-ADGroup -Name "MS-Administration" -GroupScope Global -Path "OU=Administration,OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADGroup -Name "MS-Profs" -GroupScope Global -Path "OU=Profs,OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"
New-ADGroup -Name "MS-Eleves" -GroupScope Global -Path "OU=Eleves,OU=Comptes-Utilisateurs,OU=ECOLE,DC=mediaschool,DC=local"