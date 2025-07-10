#!/usr/bin/env bash
set -euo pipefail

cd /workspace/Barnostri
ls -la

echo "🛠️  Atualizando pacotes..."
sudo apt-get update -y
sudo apt-get install -y curl git unzip xz-utils apt-transport-https gnupg

FLUTTER_DIR="$HOME/development/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "📥 Instalando Flutter SDK..."
  mkdir -p "$(dirname "$FLUTTER_DIR")"
  if [ -n "${FLUTTER_SDK_ARCHIVE:-}" ] && [ -f "$FLUTTER_SDK_ARCHIVE" ]; then
    echo "📦 Extraindo Flutter de $FLUTTER_SDK_ARCHIVE"
    tar xf "$FLUTTER_SDK_ARCHIVE" -C "$(dirname "$FLUTTER_DIR")"
  else
    echo "📥 Clonando Flutter SDK (stable)..."
    git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
  fi
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "🚀 Testando flutter e dart"
flutter --version
dart --version

echo "📦 Instala dependências"
flutter pub get -C packages/shared_models
flutter pub get -C apps/barnostri_app

echo "🎨 Formata tudo"
dart format --set-exit-if-changed packages/shared_models || true
dart format --set-exit-if-changed apps/barnostri_app || true

dart fix --dry-run
dart fix --apply

echo "🔍 Analisa"
flutter analyze packages/shared_models
flutter analyze apps/barnostri_app

echo "🧪 Testa"
(cd packages/shared_models && flutter test)
(cd apps/barnostri_app && flutter test)
(cd apps/barnostri_app && flutter test integration_test -d chrome)
echo "✅ PRONTO"
