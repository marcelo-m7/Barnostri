#!/usr/bin/env bash
set -euo pipefail

echo "🛠️ Atualizando repositórios e instalando dependências comuns..."
sudo apt update
sudo apt install -y \
  curl git unzip xz-utils zip libglu1-mesa wget \
  build-essential libssl-dev zlib1g-dev liblzma-dev libcurl4-openssl-dev \
  libgtk-3-dev openjdk-11-jdk

echo "📥 Instalando Google Chrome..."
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y /tmp/google-chrome.deb
rm /tmp/google-chrome.deb

echo "📥 Baixando Flutter SDK..."
cd ~
if [ ! -d "flutter" ]; then
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.0-stable.tar.xz
  tar xf flutter_linux_3.13.0-stable.tar.xz
  rm flutter_linux_3.13.0-stable.tar.xz
fi

echo "🔧 Configurando Flutter Git e permissões..."
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

echo "🔄 Git safe.directory extra (root)..."
git config --global --add safe.directory /root/flutter || true

# -----------------------------------------------------------------------------
# Android SDK & Licenças
# -----------------------------------------------------------------------------
echo "📥 Instalando Android SDK Command-Line Tools..."
ANDROID_SDK_ROOT="$HOME/Android/Sdk"
mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools"
cd /tmp
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip
unzip -q cmdline-tools.zip -d "${ANDROID_SDK_ROOT}/cmdline-tools"
mv "${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
rm cmdline-tools.zip

echo "🔧 Adicionando Android SDK ao PATH..."
{
  echo ""
  echo "# Flutter & Android SDK"
  echo "export ANDROID_SDK_ROOT=\"\$HOME/Android/Sdk\""
  echo "export ANDROID_HOME=\"\$HOME/Android/Sdk\""
  echo "export PATH=\"\$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:\$ANDROID_SDK_ROOT/platform-tools:\$PATH\""
} >> ~/.bashrc
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

echo "📦 Instalando plataformas Android via sdkmanager..."
yes | sdkmanager --licenses || echo "⚠️ Algumas licenças podem ter sido rejeitadas. Siga manualmente se necessário."
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2" "emulator" "system-images;android-33;google_apis;x86_64"

echo "🧾 Tentando aceitar licenças via flutter..."
yes | flutter doctor --android-licenses > /dev/null || echo "⚠️ flutter doctor --android-licenses não pôde aceitar todas as licenças automaticamente."

echo "📥 Instalando Android Studio via Snap..."
sudo snap install android-studio --classic || echo "⚠️ Android Studio não pôde ser instalado via snap. Instale manualmente se necessário."

# -----------------------------------------------------------------------------
# Verificação final
# -----------------------------------------------------------------------------
echo "🧪 Executando flutter doctor..."
flutter doctor -v || echo "⚠️ flutter doctor encontrou problemas. Verifique manualmente."

echo "✅ Ambiente de desenvolvimento Flutter + Android + Chrome configurado!"
