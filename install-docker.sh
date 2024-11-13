#!/bin/bash

# Vérification si l'utilisateur est root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté avec les privilèges root (ou via sudo)."
    exit 1
fi

# Mise à jour des paquets et installation des dépendances
echo "Mise à jour des paquets et installation des dépendances nécessaires..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG officielle de Docker
echo "Ajout de la clé GPG de Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Ajouter le dépôt Docker
echo "Ajout du dépôt Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des paquets après ajout du dépôt Docker
apt-get update

# Installer Docker et Docker Compose
echo "Installation de Docker et Docker Compose..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérifier l'installation de Docker et Docker Compose
echo "Vérification de l'installation..."
docker --version
docker-compose --version

# Ajouter l'utilisateur au groupe docker (facultatif, mais recommandé)
echo "Ajout de l'utilisateur au groupe docker..."
usermod -aG docker $USER

# Avertir l'utilisateur qu'il doit se déconnecter/reconnecter ou redémarrer la machine
echo "L'installation est terminée. Veuillez vous déconnecter et vous reconnecter ou redémarrer la machine pour que les modifications prennent effet."
