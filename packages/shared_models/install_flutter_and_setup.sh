#!/usr/bin/env bash
# Instalação do Flutter SDK em ~/development/flutter,
# configuração de PATH para o shell atual e automação de pub get, analyze e tests
# Testado em Ubuntu 22.04 LTS

set -euo pipefail

FLUTTER_ROOT="$HOME/development/flutter"
FLUTTER_BIN="$FLUTTER_ROOT/bin"
RC_FILE="$HOME/.bashrc"  # ou .zshrc se preferir

echo "🛠️  Instalando dependências (git, curl, unzip, xz-utils)..."
sudo apt-get update -y
sudo apt-get install -y git curl unzip xz-utils

echo "📥  Baixando Flutter stable..."
mkdir -p "$(dirname "$FLUTTER_ROOT")"
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_latest.tar.xz" \
  -o /tmp/flutter.tar.xz

echo "📦  Extraindo Flutter em $FLUTTER_ROOT ..."
tar xf /tmp/flutter.tar.xz -C "$(dirname "$FLUTTER_ROOT")"

# Garante que o PATH inclua flutter para este script
export PATH="$FLUTTER_BIN:$PATH"

echo "🧩  Adicionando Flutter ao PATH permanente em $RC_FILE..."
if ! grep -q 'flutter/bin' "$RC_FILE"; then
  cat << EOF >> "$RC_FILE"

# Flutter SDK
export PATH="$FLUTTER_BIN:\$PATH"
EOF
  echo "✅  PATH escrito em $RC_FILE"
else
  echo "ℹ️  PATH do Flutter já presente em $RC_FILE"
fi

echo "🚀  Atualizando Flutter para a versão mais recente stable..."
flutter channel stable
flutter upgrade --force

echo "✅  Flutter instalado! Versão:"
flutter --version

# --- agora preparo o projeto Barnostri ---

# Supondo que este script está no diretório raiz do repositório:
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$PROJECT_ROOT/apps/barnostri_app"

echo "📂  Entrando em $APP_DIR"
cd "$APP_DIR"

echo "📦  Rodando pub get no app Flutter..."
flutter pub get

echo "📝  Rodando flutter analyze (inclui análise do Flutter)..."
flutter analyze

echo "🔬  Rodando suite de testes com flutter test..."
flutter test

echo "🎉  Configuração e verificação concluídas com sucesso!"
