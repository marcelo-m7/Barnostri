#!/usr/bin/env bash
set -euo pipefail

cd /workspace/Barnostri
ls -la

echo "🛠️  Atualizando pacotes..."
sudo apt-get update -y
sudo apt-get install -y curl git unzip xz-utils apt-transport-https gnupg ca-certificates

echo "📦 Adicionando repositório oficial do Dart..."
sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/dart-archive-keyring.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart-archive-keyring.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'
sudo apt-get update -y
sudo apt-get install -y dart

echo "📥 Tentando instalar Flutter via apt..."
if ! sudo apt-get install -y flutter; then
  echo "⚠️  Instalação via apt falhou. Clonando Flutter SDK do GitHub..."
  FLUTTER_DIR="$HOME/development/flutter"
  if [ ! -d "$FLUTTER_DIR" ]; then
    mkdir -p "$(dirname "$FLUTTER_DIR")"
    git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
else
  echo "✅ Flutter instalado via apt"
fi

echo "🚀 Verificando versões do Flutter e Dart"
flutter --version 
flutter doctor -v

for dir in packages/shared_models apps/barnostri_app; do
  (cd "$dir" && flutter pub get && flutter pub upgrade)
done

dart fix --apply

echo "🔍 Analise completa"
flutter analyze || true

echo "🧪 Testes"
for dir in packages/shared_models apps/barnostri_app; do
  (cd "$dir" && flutter test) || true
done

echo "✅ Ambiente pronto"