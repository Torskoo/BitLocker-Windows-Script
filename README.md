# BitLocker-Unlock-Script

## Description
Ce script PowerShell permet de vérifier si un lecteur chiffré avec BitLocker est verrouillé et, si nécessaire, de le déverrouiller en demandant le mot de passe à l'utilisateur.

## Fonctionnalités
- Vérifie si le script est exécuté en mode administrateur et le relance avec les privilèges requis si nécessaire.
- Vérifie l'état de chiffrement du lecteur spécifié.
- Demande à l'utilisateur le mot de passe BitLocker si le lecteur est verrouillé.
- Déverrouille le lecteur en utilisant le mot de passe fourni.
- Affiche un message indiquant si le déverrouillage a réussi ou échoué.

## Prérequis
- Windows avec BitLocker activé.
- Exécution du script en mode administrateur.
- PowerShell avec les droits suffisants pour exécuter les commandes BitLocker.

## Utilisation
1. Ouvrir une console PowerShell en mode administrateur.
2. Exécuter le script :
   ```powershell
   .\bitlocker-unlock-script.ps1
