#!/bin/bash
# Post-create script for Flutter Android development container

echo "🚀 Setting up Flutter Android development environment..."

# Update system packages
if command -v apt-get &> /dev/null; then
  echo "📦 Updating package manager..."
  apt-get update -qq
  
  # Install essential tools
  echo "📦 Installing essential tools..."
  apt-get install -y -qq curl wget git unzip zip 2>/dev/null || true
fi

# Install Flutter SDK
if ! command -v flutter &> /dev/null; then
  echo "📥 Installing Flutter SDK..."
  
  if [ ! -d "$HOME/flutter" ]; then
    cd /tmp
    echo "⏳ Downloading Flutter (this takes ~1-2 minutes)..."
    curl -s -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz -o flutter.tar.xz
    
    echo "📦 Extracting Flutter..."
    tar -xf flutter.tar.xz -C "$HOME"
    rm -f flutter.tar.xz
    cd - > /dev/null
  fi
  
  export PATH="$HOME/flutter/bin:$PATH"
  
  # Update shell rc files to include Flutter in PATH
  for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile"; do
    if [ -f "$rc" ] && ! grep -q "flutter/bin" "$rc"; then
      echo 'export PATH="$HOME/flutter/bin:$PATH"' >> "$rc"
    fi
  done
fi

# Ensure Flutter is in PATH for this session
export PATH="$HOME/flutter/bin:$PATH"

# Configure Flutter
echo "✨ Configuring Flutter..."
flutter config --no-analytics --no-crash-reporting 2>/dev/null || true

# Get project dependencies
if [ -f "/workspaces/Flutter-Android-App-CodeSpaces/pubspec.yaml" ]; then
  echo "📚 Getting project dependencies..."
  cd /workspaces/Flutter-Android-App-CodeSpaces
  flutter pub get 2>/dev/null || true
fi

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
if flutter --version 2>/dev/null; then
  echo ""
  echo "✅ Flutter setup completed successfully!"
  
  # Run flutter doctor for informational purposes (don't fail on warnings)
  echo ""
  echo "📋 Environment check (flutter doctor):"
  flutter doctor 2>/dev/null || true
  
  echo ""
  echo "🚀 Quick start commands:"
  echo "  flutter run           - Run app on device/emulator"
  echo "  flutter build apk     - Build Android APK"
  echo "  flutter test          - Run tests"
  echo "  make help             - View all available commands"
else
  echo "⚠️  Flutter installation may be incomplete"
  exit 1
fi

