@echo off
setlocal

:: Vérifier si le script est exécuté en tant qu'administrateur
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Ce script nécessite des privilèges administratifs.
    echo Relancement en mode administrateur...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Aller au dossier où se trouve le fichier .bat
cd /d "%~dp0"

:: Vérification de Node.js
echo Vérification de Node.js...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js n'est pas installé. Téléchargement en cours...

    :: Définir le lien de téléchargement et le chemin de sauvegarde
    set "nodejs_url=https://nodejs.org/dist/v22.12.0/node-v22.12.0-x64.msi"
    set "installer_path=%TEMP%\nodejs_installer.msi"

    :: Télécharger Node.js
    powershell -Command "Invoke-WebRequest -Uri %nodejs_url% -OutFile %installer_path%"
    if %errorlevel% neq 0 (
        echo Erreur lors du téléchargement de Node.js.
        pause
        exit /b
    )

    :: Installation de Node.js
    echo Installation de Node.js...
    msiexec /i "%installer_path%" /quiet /norestart
    if %errorlevel% neq 0 (
        echo Erreur lors de l'installation de Node.js.
        pause
        exit /b
    )

    :: Suppression du fichier d'installation
    del /f "%installer_path%"
)

:: Lancement de npm run dev
echo Démarrage du projet avec npm run dev...
start cmd /k "npm run dev"

:: Ouvrir le navigateur à l'adresse localhost:5173
echo Ouverture du navigateur à http://localhost:5173...
start "" "http://localhost:5173"

pause