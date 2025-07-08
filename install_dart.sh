#!/usr/bin/env bash
# Instalação do Dart SDK via repositório oficial (estável)
# Testado em Ubuntu 22.04 LTS

set -euo pipefail

echo "🛠️  Atualizando cache de pacotes..."
sudo apt-get update -y
sudo apt-get install -y curl apt-transport-https gnupg

echo "🔑  Importando chave GPG do Google..."
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub |
  sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg

echo "📦  Adicionando repositório do Dart..."
echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] \
https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" |
  sudo tee /etc/apt/sources.list.d/dart_stable.list

echo "📥  Instalando Dart SDK..."
sudo apt-get update -y
sudo apt-get install -y dart

echo "✅  Dart instalado! Versão:"
dart --version
