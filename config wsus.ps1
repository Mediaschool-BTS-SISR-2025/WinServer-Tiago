# 6. Post-installation WSUS (stockage local) [cite: 167]
Write-Host "Post-installation de WSUS..." -f Yellow
New-Item -Path "D:\WSUS" -ItemType Directory
& "C:\Program Files\Update Services\Tools\wsusutil.exe" postinstall CONTENT_DIR=D:\WSUS

# 7. Configuration WSUS (Produits, Classifications, Groupes)
Write-Host "Configuration de WSUS (Produits, Classes, Groupes)..." -f Yellow
$wsusServer = Get-WsusServer -Name "localhost" -PortNumber 8530

# 8. Synchro depuis Microsoft [cite: 169]
$wsusServer | Set-WsusServerSynchronization -SyncFromMicrosoftUpdate

# 9. Désactiver tous les produits (pour repartir à zéro)
$wsusServer | Get-WsusProduct | Where-Object { $_.IsSubscribed } | Set-WsusProduct -Disable

# 10. Activer les produits requis [cite: 170]
$wsusServer | Get-WsusProduct -TitleIncludes "Windows 10" | Set-WsusProduct
$wsusServer | Get-WsusProduct -TitleIncludes "Windows 11" | Set-WsusProduct
$wsusServer | Get-WsusProduct -TitleIncludes "Windows Server 2022" | Set-WsusProduct

# 11. Configurer les classifications [cite: 171]
$classifications = "Critical Updates", "Security Updates", "Definition Updates"
$wsusServer | Get-WsusClassification | Set-WsusClassification -Disable
$classifications | ForEach-Object { $wsusServer | Get-WsusClassification -Title $_ | Set-WsusClassification }

# 12. Créer les groupes WSUS [cite: 174]
$wsusServer.CreateComputerTargetGroup("WSUS-Pilote")
$wsusServer.CreateComputerTargetGroup("WSUS-Production")

# 13. Créer la règle d'approbation auto pour Pilote [cite: 188]
$piloteGroup = $wsusServer.GetComputerTargetGroupByName("WSUS-Pilote")
$classificationsToAutoApprove = $wsusServer | Get-WsusClassification -Title "Security Updates", "Definition Updates"
$wsusServer.CreateUpdateApprovalRule("AutoApprove Pilote Security/Defs", $piloteGroup, $classificationsToAutoApprove)

# 14. Lancer la première synchro (prendra du temps)
Invoke-WsusServerSynchronization -Server $wsusServer