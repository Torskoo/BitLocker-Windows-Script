# 🔐 BitLocker-Windows-Script

## 📜 Description  
Ce script PowerShell permet de gérer facilement les lecteurs chiffrés avec BitLocker sous Windows. Il offre une interface interactive permettant d'afficher l'état des lecteurs, de les déverrouiller, de les verrouiller et de sauvegarder la clé de récupération.

## ✨ Fonctionnalités  
✔ Vérification et relance automatique en mode administrateur.  
✔ Détection et affichage de l'état des lecteurs BitLocker.  
✔ Déverrouillage sécurisé avec demande de mot de passe.  
✔ Verrouillage d'un lecteur chiffré.  
✔ Sauvegarde automatique de la clé de récupération.  
✔ Interface utilisateur colorée pour une meilleure lisibilité.  
✔ Journalisation des actions dans un fichier log.  
✔ Sélection des lecteurs via un menu interactif.  

## 🖥 Prérequis  
🔹 Windows avec BitLocker activé.  
🔹 Exécution du script en mode administrateur.  
🔹 PowerShell avec les droits suffisants pour exécuter les commandes BitLocker.  

## 🚀 Utilisation  
1️⃣ Ouvrir une console PowerShell en mode administrateur.  
2️⃣ Exécuter le script avec la commande suivante :  
```
.\bitlocker-windows-script.ps1
```
3️⃣ Suivre les instructions affichées à l'écran.  

## 📁 Notes  
📌 **Le fichier de récupération est sauvegardé sous :**
```
C:\BitLocker-RecoveryKey-<lettre_du_lecteur>.txt
```

📌 **Un fichier journal enregistre les actions sous :**  
```
C:\BitLocker-Log.txt
```


## ⚠️ Avertissement  
Ce script est fourni "tel quel", sans garantie. Utilisez-le à vos propres risques.  
Vérifiez toujours l'intégrité de vos données avant d'effectuer des actions sur BitLocker. 
