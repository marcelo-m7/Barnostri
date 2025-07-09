#!/usr/bin/env bash
set -euo pipefail

echo "🛠️  Atualizando pacotes..."
apt-get update -y
apt-get install -y curl git unzip xz-utils apt-transport-https gnupg

FLUTTER_DIR="$HOME/development/flutter"
if [[ ! -d "$FLUTTER_DIR" ]]; then
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
fi

echo 'export PATH="$FLUTTER_DIR/bin:$PATH"' >> /etc/profile.d/flutter.sh
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter doctor -v

for dir in packages/shared_models apps/barnostri_app; do
  (cd "$dir" && flutter pub get && flutter pub upgrade)
done

dart fix --apply

echo "🔍 Analise completa"
flutter analyze

echo "🧪 Testes"
for dir in packages/shared_models apps/barnostri_app; do
  (cd "$dir" && flutter test)
done

echo "✅ Ambiente pronto"

