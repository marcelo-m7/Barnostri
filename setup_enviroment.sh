#!/usr/bin/env bash
set -euo pipefail

cd /workspace/Barnostri
ls -la

echo "🛠️  Atualizando pacotes..."
sudo apt-get update -y || true
sudo apt-get install -y curl git unzip xz-utils apt-transport-https gnupg || true

FLUTTER_DIR="$HOME/development/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "📥 Clonando Flutter SDK (stable)..."
  mkdir -p "$(dirname "$FLUTTER_DIR")"
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR" || true
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "🚀 Testando flutter e dart"
flutter --version || true
dart --version || true

echo "📦 Instala dependências"
flutter pub get -C packages/shared_models || true
flutter pub get -C apps/barnostri_app || true

echo "🎨 Formata tudo"
dart format --set-exit-if-changed packages/shared_models || true
dart format --set-exit-if-changed apps/barnostri_app || true

echo "🔍 Analisa"
flutter analyze packages/shared_models || true
flutter analyze apps/barnostri_app || true

echo "🧪 Testa"
flutter test packages/shared_models || true
flutter test apps/barnostri_app || true

echo "✅ PRONTO"
