# Vérifier si le script est exécuté en mode administrateur
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
$AdminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $Principal.IsInRole($AdminRole)) {
    Write-Host "Relance du script en mode administrateur..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Demander la lettre du lecteur
$DriveLetter = "D:"  # Remplace si nécessaire

# Vérifier le statut du lecteur
$Status = Get-BitLockerVolume -MountPoint $DriveLetter

if ($Status.VolumeStatus -eq "FullyDecrypted") {
    Write-Host "Le lecteur $DriveLetter est déjà déverrouillé." -ForegroundColor Green
} else {
    # Demander le mot de passe
    $Password = Read-Host "Entrez le mot de passe BitLocker" -AsSecureString

    # Déverrouiller le disque
    Unlock-BitLocker -MountPoint $DriveLetter -Password $Password

    # Vérifier si le déverrouillage a réussi
    $Status = Get-BitLockerVolume -MountPoint $DriveLetter
    if ($Status.VolumeStatus -eq "FullyDecrypted") {
        Write-Host "Le lecteur $DriveLetter est déverrouillé avec succès !" -ForegroundColor Green
    } else {
        Write-Host "Échec du déverrouillage. Vérifiez le mot de passe." -ForegroundColor Red
    }
}