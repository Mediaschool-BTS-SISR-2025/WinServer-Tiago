# 6. Autorisation du DHCP dans l'AD [cite: 48]
Write-Host "Configuration du DHCP..." -f Yellow
Add-DhcpServerInDC

# 7. Création du Scope DHCP [cite: 49-57]
$poolStart = "192.168.100.50"
$poolEnd = "192.168.100.200"
$gateway = "192.168.100.1"
$dnsServer = "192.168.100.10"
$domainName = "mediaschool.local"
[cite_start]$leaseDuration = (New-TimeSpan -Hours 6) # [cite: 52]

Add-DhcpServerv4Scope -Name "SCOPE-SALLE-INFO" -StartRange $poolStart -EndRange $poolEnd -SubnetMask 255.255.255.0 -LeaseDuration $leaseDuration

# 8. Configuration des Options du Scope
[cite_start]Set-DhcpServerv4OptionValue -ScopeId $poolStart -OptionId 3 -Value $gateway                 # 003 Router [cite: 55]
[cite_start]Set-DhcpServerv4OptionValue -ScopeId $poolStart -OptionId 6 -Value $dnsServer               # 006 DNS Servers [cite: 56]
[cite_start]Set-DhcpServerv4OptionValue -ScopeId $poolStart -OptionId 15 -Value $domainName            # 015 DNS Domain Name [cite: 57]

# 9. Activation des mises à jour DNS sécurisées [cite: 58]
Set-DhcpServerv4Scope -ScopeId $poolStart -DynamicUpdates "Secure"