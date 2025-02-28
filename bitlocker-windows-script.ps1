# Verifier si le script est execute en mode administrateur
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
$AdminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $Principal.IsInRole($AdminRole)) {
    Write-Host "Relance du script en mode administrateur..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Variables globales
$LogFile = "C:\BitLocker-Script-Log.txt"
$PasswordFile = "C:\BitLocker-Pass.secure"

# Fonction pour enregistrer les logs
function Log-Action {
    param ($Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp - $Message" | Out-File -Append -FilePath $LogFile
}

# Fonction pour obtenir le statut BitLocker des lecteurs
function Get-BitLockerStatus {
    Write-Host "=== Etat des lecteurs BitLocker ===" -ForegroundColor Cyan
    Get-BitLockerVolume | ForEach-Object {
        Write-Host "Lecteur: $($_.MountPoint) - Statut: $($_.VolumeStatus)" -ForegroundColor Magenta
    }
}

# Fonction pour selectionner un lecteur interactif
function Select-Drive {
    $Drives = Get-BitLockerVolume | Select-Object -ExpandProperty MountPoint
    if ($Drives.Count -eq 0) {
        Write-Host "Aucun lecteur BitLocker detecte." -ForegroundColor Red
        return $null
    }
    $Drive = $Drives | Out-GridView -PassThru -Title "Selectionnez un lecteur"
    return $Drive
}

# Fonction pour deverrouiller un lecteur
function Unlock-Drive {
    Write-Host "=== Deverrouillage d'un lecteur BitLocker ===" -ForegroundColor Cyan
    $DriveLetter = Select-Drive
    if (-not $DriveLetter) { return }
    
    $Status = Get-BitLockerVolume -MountPoint $DriveLetter
    if ($Status.VolumeStatus -eq "FullyDecrypted") {
        Write-Host "Le lecteur $DriveLetter est deja deverrouille." -ForegroundColor Green
        return
    }

    $SecurePassword = Read-Host "Entrez le mot de passe BitLocker" -AsSecureString

    Write-Progress -Activity "Deverrouillage en cours..." -Status "Veuillez patienter"
    Unlock-BitLocker -MountPoint $DriveLetter -Password $SecurePassword
    Start-Sleep -Seconds 2

    $Status = Get-BitLockerVolume -MountPoint $DriveLetter
    if ($Status.VolumeStatus -eq "FullyDecrypted") {
        Write-Host "Le lecteur $DriveLetter est deverrouille avec succes !" -ForegroundColor Green
        Log-Action "Deverrouillage reussi du lecteur $DriveLetter"
    } else {
        Write-Host "Le deverrouillage a peut-etre reussi, mais le statut n'a pas ete mis a jour immediatement." -ForegroundColor Yellow
    }
}

# Fonction pour verrouiller un lecteur
function Lock-Drive {
    Write-Host "=== Verrouillage d'un lecteur BitLocker ===" -ForegroundColor Cyan
    $DriveLetter = Select-Drive
    if (-not $DriveLetter) { return }

    $Confirm = Read-Host "Voulez-vous vraiment verrouiller $DriveLetter ? (o/n)"
    if ($Confirm -ne "o") { return }

    Write-Progress -Activity "Verrouillage en cours..." -Status "Veuillez patienter"
    Lock-BitLocker -MountPoint $DriveLetter
    Write-Host "Le lecteur $DriveLetter a ete verrouille." -ForegroundColor Yellow
    Log-Action "Lecteur $DriveLetter verrouille"
}

# Fonction pour sauvegarder la cle de recuperation
function Backup-RecoveryKey {
    Write-Host "=== Sauvegarde de la cle de recuperation ===" -ForegroundColor Cyan
    $DriveLetter = Select-Drive
    if (-not $DriveLetter) { return }

    $KeyProtector = Get-BitLockerVolume -MountPoint $DriveLetter | Select-Object -ExpandProperty KeyProtector
    $RecoveryKey = $KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
    if ($RecoveryKey) {
        $SafeDriveLetter = $DriveLetter -replace "[:\\]", "_"
        $FilePath = "C:\BitLocker-RecoveryKey-$SafeDriveLetter.txt"
        $RecoveryKey.RecoveryPassword | Out-File -FilePath $FilePath
        Write-Host "Cle de recuperation sauvegardee ici: $FilePath" -ForegroundColor Green
        Log-Action "Cle de recuperation sauvegardee pour $DriveLetter"
    } else {
        Write-Host "Aucune cle de recuperation trouvee pour $DriveLetter." -ForegroundColor Red
    }
}

# Fonction pour chiffrer un lecteur
function Encrypt-Drive {
    Write-Host "=== Chiffrement d'un lecteur BitLocker ===" -ForegroundColor Cyan
    $DriveLetter = Select-Drive
    if (-not $DriveLetter) { return }

    Write-Progress -Activity "Chiffrement en cours..." -Status "Veuillez patienter"
    Enable-BitLocker -MountPoint $DriveLetter -PasswordProtector
    Write-Host "Le chiffrement a ete active sur $DriveLetter." -ForegroundColor Green
    Log-Action "Chiffrement active sur $DriveLetter"
}

# Menu principal
while ($true) {
    Write-Host "=================================" -ForegroundColor Blue
    Write-Host "        MENU BITLOCKER" -ForegroundColor Yellow
    Write-Host "=================================" -ForegroundColor Blue
    Write-Host "1. Afficher l'etat des lecteurs" -ForegroundColor Cyan
    Write-Host "2. Deverrouiller un lecteur" -ForegroundColor Cyan
    Write-Host "3. Verrouiller un lecteur" -ForegroundColor Cyan
    Write-Host "4. Sauvegarder la cle de recuperation" -ForegroundColor Cyan
    Write-Host "5. Chiffrer un lecteur avec BitLocker" -ForegroundColor Cyan
    Write-Host "6. Quitter" -ForegroundColor Red
    Write-Host "=================================" -ForegroundColor Blue
    
    $Choice = Read-Host "Choisissez une option"
    
    switch ($Choice) {
        "1" { Get-BitLockerStatus }
        "2" { Unlock-Drive }
        "3" { Lock-Drive }
        "4" { Backup-RecoveryKey }
        "5" { Encrypt-Drive }
        "6" { exit }
        default { Write-Host "Option invalide, veuillez reessayer." -ForegroundColor Red }
    }
}
