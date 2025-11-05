# 3. Création du partage pour les dossiers personnels
Write-Host "Création du partage et configuration FSRM..." -f Yellow
New-Item -Path "D:\Donnees\Homes" -ItemType Directory
New-SmbShare -Name "Homes" -Path "D:\Donnees\Homes" -FullAccess "Tout le monde"
# (Note: Les permissions NTFS sont plus importantes, 'Tout le monde' est pour le partage)
# (La GPO s'occupera des permissions NTFS lors de la création du dossier perso)

# 4. Création des modèles de quotas FSRM [cite: 71-75]
New-FsrmQuotaTemplate -Name "Template-Eleves (1 Go)" -Limit 1GB -Threshold 85
New-FsrmQuotaTemplate -Name "Template-Profs (5 Go)" -Limit 5GB -Threshold 85
New-FsrmQuotaTemplate -Name "Template-Admin (10 Go)" -Limit 10GB -Threshold 85

# 5. Application d'un quota auto-généré sur le dossier Homes
# (Ceci appliquera un quota à chaque NOUVEAU dossier créé dans Homes)
New-FsrmAutoQuota -Path "D:\Donnees\Homes" -Template "Template-Eleves (1 Go)" -UpdateMatchingQuotas
# (Note: Vous devriez changer le template appliqué en fonction du groupe,
# ce qui est complexe en PS. 'Template-Eleves' est une base.)