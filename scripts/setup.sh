#!/bin/bash

# Script de configuration pour le projet Calypso

echo "🔧 Initialisation de la configuration de Calypso..."

# Étape 1 : Vérification de Ruby
if ! command -v ruby &> /dev/null; then
  echo "Ruby n'est pas installé. Veuillez installer Ruby pour continuer."
  exit 1
fi

# Étape 2 : Vérification de Bundler
if ! gem list bundler -i > /dev/null; then
  echo "Installation de Bundler..."
  gem install bundler
fi

# Étape 3 : Installation des gems
echo "Installation des dépendances Ruby..."
bundle install || { echo "Erreur lors de l'installation des gems. Vérifiez votre environnement."; exit 1; }

# Étape 4 : Vérification des dépendances système
echo "Vérification des dépendances système..."
if ! dpkg -l | grep libncurses5-dev > /dev/null; then
  echo "Installation des bibliothèques nécessaires..."
  sudo apt update && sudo apt install -y libncurses5-dev libncursesw5-dev
fi

# Étape 5 : Configuration du fichier .env
if [ ! -f .env ]; then
  echo "Configuration du fichier .env..."
  cat <<EOT >> .env
SERVER_IP=0.0.0.0
SERVER_PORT=3630
SECRET_KEY=SECRET_STAR_WARS_42
EOT
else
  echo ".env existe déjà, configuration ignorée."
fi

echo "✅ Configuration terminée. Vous pouvez maintenant démarrer le serveur."
