# --- PARTIE MANUELLE ---
# Avant d'exécuter la suite, installez l'ADK, le WinPE Addon, et MDT
# (Exécutez les installeurs que vous avez téléchargés)
# Write-Host "Veuillez installer ADK, WinPE et MDT manuellement, puis appuyez sur Entrée"
# Read-Host

# 15. Initialisation de WDS [cite: 201]
Write-Host "Initialisation de WDS..." -f Yellow
Initialize-WdsServer -WdsClientNBP \Boot\x64\wdsnbp.com -NewDC

# 16. Importation du module MDT
Write-Host "Importation du module MDT..." -f Yellow
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\Microsoft.Deployment.Toolkit.psd1"

# 17. Création du Deployment Share MDT [cite: 202, 211]
$mdtPath = "D:\MDT"
New-MDTDeploymentShare -Name "MDTShare" -Path $mdtPath -Description "MDT Deployment Share"

# 18. Importation de l'OS (suppose l'ISO sur E:) [cite: 211]
Import-MDTOperatingSystem -Path "$mdtPath\Operating Systems" -SourcePath "E:\sources\install.wim" -Name "Windows 11 Pro (Base)"

# 19. Création de la Task Sequence [cite: 212]
New-MDTTaskSequence -Path "$mdtPath\Task Sequences" -Name "Deploy-W11-Standard" -Template "Client.xml" -OSName "Windows 11 Pro (Base)"

# 20. Mise à jour du Share (génère les images de boot) [cite: 213]
Write-Host "Mise à jour du Deployment Share... (Patientez, c'est long)" -f Yellow
Update-MDTDeploymentShare -Path $mdtPath

# 21. Ajout de l'image de boot MDT à WDS [cite: 214]
Write-Host "Ajout de l'image de boot à WDS..." -f Yellow
Import-WdsBootImage -Path "$mdtPath\Boot\LiteTouchPE_x64.wim" -Name "MDT LiteTouch x64"