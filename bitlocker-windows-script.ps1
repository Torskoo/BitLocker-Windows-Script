# Vérifier si le script est exécuté en mode administrateur
$CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)
$AdminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $Principal.IsInRole($AdminRole)) {
    Write-Host "Relance du script en mode administrateur..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Activer l'encodage UTF-8
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-BitLockerStatus {
    Write-Host "=== Etat des lecteurs BitLocker ===" -ForegroundColor Cyan
    Get-BitLockerVolume | ForEach-Object {
        Write-Host "Lecteur: $($_.MountPoint) - Statut: $($_.VolumeStatus)" -ForegroundColor Magenta
    }
}

function Unlock-Drive {
    Write-Host "=== Deverrouillage d'un lecteur BitLocker ===" -ForegroundColor Cyan
    $DriveLetter = Read-Host "Entrez la lettre du lecteur (ex: D:)"
    $Status = Get-BitLockerVolume -MountPoint $DriveLetter
    
    if ($Status.VolumeStatus -eq "FullyDecrypted") {
        Write-Host "Le lecteur $DriveLetter est deja deverrouille." -ForegroundColor Green
    } else {
        $Password = Read-Host "Entrez le mot de passe BitLocker" -AsSecureString
        Unlock-BitLocker -MountPoint $DriveLetter -Password $Password
        Start-Sleep -Seconds 2 
        $Status = Get-BitLockerVolume -MountPoint $DriveLetter
        if ($Status.VolumeStatus -eq "FullyDecrypted") {
            Write-Host "Le lecteur $DriveLetter est deverrouille avec succes !" -ForegroundColor Green
        }
    }
}

function Lock-Drive {
    Write-Host "=== Verrouillage d'un lecteur BitLocker ===" -ForegroundColor Cyan
    $DriveLetter = Read-Host "Entrez la lettre du lecteur a verrouiller (ex: D:)"
    Lock-BitLocker -MountPoint $DriveLetter
    Write-Host "Le lecteur $DriveLetter a ete verrouille." -ForegroundColor Yellow
}

function Backup-RecoveryKey {
    Write-Host "=== Sauvegarde de la cle de recuperation ===" -ForegroundColor Cyan
    $DriveLetter = Read-Host "Entrez la lettre du lecteur pour sauvegarder la cle de recuperation (ex: D:)"
    $KeyProtector = Get-BitLockerVolume -MountPoint $DriveLetter | Select-Object -ExpandProperty KeyProtector
    $RecoveryKey = $KeyProtector | Where-Object { $_.KeyProtectorType -eq "RecoveryPassword" }
    if ($RecoveryKey) {
        $FilePath = "C:\BitLocker-RecoveryKey-$DriveLetter.txt"
        $RecoveryKey.RecoveryPassword | Out-File -FilePath $FilePath
        Write-Host "Cle de recuperation sauvegardee ici: $FilePath" -ForegroundColor Green
    } else {
        Write-Host "Aucune cle de recuperation trouvee pour $DriveLetter." -ForegroundColor Red
    }
}

while ($true) {
    Write-Host "=================================" -ForegroundColor Blue
    Write-Host "        MENU BITLOCKER" -ForegroundColor Yellow
    Write-Host "=================================" -ForegroundColor Blue
    Write-Host "1. Afficher l'etat des lecteurs" -ForegroundColor Cyan
    Write-Host "2. Deverrouiller un lecteur" -ForegroundColor Cyan
    Write-Host "3. Verrouiller un lecteur" -ForegroundColor Cyan
    Write-Host "4. Sauvegarder la cle de recuperation" -ForegroundColor Cyan
    Write-Host "5. Quitter" -ForegroundColor Red
    Write-Host "=================================" -ForegroundColor Blue
    
    $Choice = Read-Host "Choisissez une option"
    
    switch ($Choice) {
        "1" { Get-BitLockerStatus }
        "2" { Unlock-Drive }
        "3" { Lock-Drive }
        "4" { Backup-RecoveryKey }
        "5" { exit }
        default { Write-Host "Option invalide, veuillez réessayer." -ForegroundColor Red }
    }
}