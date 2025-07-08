#!/usr/bin/env bash
set -euo pipefail

cd /workspace/Barnostri
ls -la

echo "🛠️  Atualizando pacotes..."
sudo apt-get update -y
sudo apt-get install -y curl git unzip xz-utils apt-transport-https gnupg

FLUTTER_DIR="$HOME/development/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "📥 Clonando Flutter SDK (stable)..."
  mkdir -p "$(dirname "$FLUTTER_DIR")"
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "🚀 Testando flutter e dart"
flutter --version
dart --version

echo "📦 Instala dependências"
flutter pub get -C packages/shared_models
flutter pub get -C apps/barnostri_app

echo "🎨 Formata tudo"
flutter format --set-exit-if-changed packages/shared_models
flutter format --set-exit-if-changed apps/barnostri_app

echo "🔍 Analisa"
flutter analyze packages/shared_models
flutter analyze apps/barnostri_app

echo "🧪 Testa"
flutter test -C packages/shared_models
flutter test -C apps/barnostri_app

echo "✅ PRONTO"
