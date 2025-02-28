# BitLocker-Windows-Script

## \ud83d\udc1c Description  
Ce script PowerShell permet de gérer facilement les lecteurs chiffrés avec BitLocker sous Windows. Il offre une interface interactive permettant d'afficher l'état des lecteurs, de les déverrouiller, de les verrouiller et de sauvegarder la clé de récupération.

## \u2728 Fonctionnalités  
\u2714 Vérification et relance automatique en mode administrateur.  
\u2714 Détection et affichage de l'état des lecteurs BitLocker.  
\u2714 Déverrouillage sécurisé avec demande de mot de passe.  
\u2714 Verrouillage d'un lecteur chiffré.  
\u2714 Sauvegarde automatique de la clé de récupération.  
\u2714 Interface utilisateur colorée pour une meilleure lisibilité.  

## \ud83d\udda5 Prérequis  
\ud83d\udcaa Windows avec BitLocker activé.  
\ud83d\udcaa Exécution du script en mode administrateur.  
\ud83d\udcaa PowerShell avec les droits suffisants pour exécuter les commandes BitLocker.  

## \ud83d\ude80 Utilisation  
1\ufe0f\u20e3 Ouvrir une console PowerShell en mode administrateur.  
2\ufe0f\u20e3 Exécuter le script avec la commande suivante :  
   ```powershell
   .\BitLocker-Windows-Script.ps1
   ```
3\ufe0f\u20e3 Naviguer dans le menu et choisir une option en entrant son numéro.  

## \ud83d\udccc Notes  
- L'affichage des caractères accentués est corrigé grâce à l'utilisation de l'encodage UTF-8.  
- Après le déverrouillage, un délai de 2 secondes est appliqué pour assurer la mise à jour du statut du lecteur.  

