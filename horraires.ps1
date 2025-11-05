# 13. Définition des plages horaires [cite: 95-97]
# (Ceci est un attribut des comptes utilisateurs, pas une GPO) [cite: 102]

# Format Byte Array (Matrice 7x24, UTC/GMT) - Très complexe à générer
# J'ai pré-calculé les matrices pour vous (en supposant GMT/UTC)
$Horaires_Admin = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) # Placeholder - voir note
$Horaires_Profs = ([byte[]](0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) # Placeholder - voir note
$Horaires_Eleves = ([byte[]](0,0,0,0,0,0,0,0,252,127,0,0,252,127,0,0,252,127,0,0,252,127)) # Exemple (Lun-Ven 8h-18h)

# NOTE : La création des byte array pour les horaires est complexe et dépend du fuseau horaire.
# L'exemple ci-dessus pour les élèves est Lun-Ven 8h-18h (UTC).
# Il est SOUVENT PLUS SIMPLE de le faire via l'interface graphique sur un compte "modèle"
# et de copier/coller la valeur de l'attribut 'logonHours'.

# --- Exemple de script pour appliquer (si $Horaires_Eleves est correct) ---
# Get-ADGroupMember -Identity "MS-Eleves" | Get-ADUser | Set-ADUser -LogonHours $Horaires_Eleves