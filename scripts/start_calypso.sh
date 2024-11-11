#!/bin/bash

# Script pour démarrer tous les services de Calypso

echo "🚀 Démarrage des services de Calypso..."

# Démarrage du serveur principal
echo "Démarrage du serveur principal..."
ruby ser.rb &
SER_PID=$!
echo "Serveur principal démarré avec PID : $SER_PID"

# Démarrage du serveur WebRTC
echo "Démarrage du serveur WebRTC..."
ruby webrtc_server.rb &
WEBRTC_PID=$!
echo "Serveur WebRTC démarré avec PID : $WEBRTC_PID"

# Fonction pour arrêter les services proprement
stop_services() {
  echo "⏹ Arrêt des services..."
  kill $SER_PID $WEBRTC_PID 2>/dev/null
  echo "Tous les services ont été arrêtés."
}

# Trap pour attraper les signaux (Ctrl+C)
trap stop_services INT TERM

# Attente infinie pour garder le script actif
echo "✅ Tous les services sont opérationnels. Appuyez sur Ctrl+C pour arrêter."
while true; do
  sleep 1
done
