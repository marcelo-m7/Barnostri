#!/usr/bin/env bash
set -euo pipefail

cd /workspace/Barnostri
ls -la

echo "🔧 Configurando ambiente de desenvolvimento Barnostri"

echo "🛠️ Instalando dependências do sistema..."
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa wget

echo "📥 Instalando Google Chrome..."
wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome.deb
rm google-chrome.deb

echo "📥 Baixando Flutter SDK (canal stable)..."
cd ~
if [ ! -d "flutter" ]; then
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.0-stable.tar.xz
  tar xf flutter_linux_3.13.0-stable.tar.xz
  rm flutter_linux_3.13.0-stable.tar.xz
fi

echo "🔧 Corrigindo permissões e Git do Flutter..."
cd ~/flutter
git config --global --add safe.directory "$PWD"
git init
git remote add origin https://github.com/flutter/flutter.git || true
git fetch origin
git checkout stable

echo "🔧 Adicionando Flutter ao PATH..."
if ! grep -q 'flutter/bin' ~/.bashrc; then
  echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/flutter/bin:$PATH"

echo "🔄Git Config "
git config --global --add safe.directory /root/flutter

echo "🧪 Verificando instalação com flutter doctor..."
flutter doctor

echo "🎨 Formata tudo"
dart format --set-exit-if-changed packages/shared_models || true
dart format --set-exit-if-changed apps/barnostri_app || true

dart fix --dry-run
dart fix --apply

echo "📝​ Aplicando Flutter Create.."
flutter create --org com.barnostri --project-name barnostri_app --platforms=web,linux,macos,windows,android apps/barnostri_app

echo "🔍 Analisa"
flutter analyze packages/shared_models
flutter analyze apps/barnostri_app

echo "🧪 Testa"
(cd packages/shared_models && flutter test)
(cd apps/barnostri_app && flutter test)
(cd apps/barnostri_app && flutter test integration_test -d chrome)

echo "✅ PRONTO"
