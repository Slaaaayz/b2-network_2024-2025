#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

if ! command -v wg &> /dev/null; then
    echo "WireGuard n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)

RANDOM_IP=$((RANDOM % 244 + 10))
GATEWAY="10.7.2.1"

CLIENT_CONF="/etc/wireguard/client.conf"
cat <<EOL > $CLIENT_CONF
[Interface]
PrivateKey = $PRIVATE_KEY
Address = 10.7.2.${RANDOM_IP}/24

[Peer]
PublicKey = zFvhh+eW4myExW7Dd9dMmMCwuMBXwtodd6oBvEruu2A=
AllowedIPs = 0.0.0.0/0
Endpoint = 10.7.1.100:13337
EOL


echo '
  ____               _____   _                       
 |  _ \             / ____| | |                      
 | |_) |  _   _    | (___   | |   __ _   _   _   ____
 |  _ <  | | | |    \___ \  | |  / _` | | | | | |_  /
 | |_) | | |_| |    ____) | | | | (_| | | |_| |  / / 
 |____/   \__, |   |_____/  |_|  \__,_|  \__, | /___|
           __/ |                          __/ |      
          |___/                          |___/       
'

sleep 5


echo "-------------------------------------------------"
echo "La clé publique du client est :"
echo "$PUBLIC_KEY"
echo "-------------------------------------------------"
echo "Ajoutez cette clé publique au serveur WireGuard avec l'adresse IP : 10.7.2.${RANDOM_IP}/32"
echo "Voici le contenu du [peer] à ajouter au serveur :"
echo "-------------------------------------------------"
echo "[Peer]"
echo "PublicKey = $PUBLIC_KEY"
echo "AllowedIPs = 10.7.2.${RANDOM_IP}/32"
echo "-------------------------------------------------"

echo "Creation des alias pour les interfaces..."
sleep 5
echo "Alias crée : vpn-up et vpn-down"

echo "alias vpn-up='wg-quick up client'" >> ~/.bashrc
echo "alias vpn-down='wg-quick down client'" >> ~/.bashrc
source ~/.bashrc

echo "Activation de l'interface WireGuard..."
sleep 5
wg-quick up client

echo "Ajout de la route par défaut via le VPN..."
sleep 5
ip route add default via "$GATEWAY"


echo "Configuration du client WireGuard terminée. Le fichier de configuration est situé dans $CLIENT_CONF."