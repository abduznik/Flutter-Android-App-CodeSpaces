#!/bin/bash
# Post-create script for Flutter Android development container

echo "🚀 Setting up Flutter Android development environment..."

# Try using system Flutter first, if available
if command -v flutter &> /dev/null; then
  FLUTTER_PATH=$(which flutter)
  echo "✓ Found Flutter at: $FLUTTER_PATH"
else
  # Install Flutter manually if the feature didn't work
  echo "📥 Flutter feature not available, installing manually..."
  
  if [ ! -d "$HOME/flutter" ]; then
    echo "⏳ Downloading Flutter SDK..."
    cd /tmp
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz -o flutter.tar.xz 2>/dev/null
    
    echo "📦 Extracting Flutter..."
    tar -xf flutter.tar.xz -C "$HOME"
    rm -f flutter.tar.xz
    cd - > /dev/null
  fi
  
  export PATH="$HOME/flutter/bin:$PATH"
  
  # Update shell profiles
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$rc" ] && ! grep -q "flutter/bin" "$rc"; then
      echo 'export PATH="$HOME/flutter/bin:$PATH"' >> "$rc"
    fi
  done
fi

# Configure Flutter
echo "✨ Initializing Flutter..."
flutter config --no-analytics --quiet 2>/dev/null || true

# Get project dependencies
if [ -f "/workspaces/Flutter-Android-App-CodeSpaces/pubspec.yaml" ]; then
  echo "📚 Getting Flutter dependencies..."
  cd /workspaces/Flutter-Android-App-CodeSpaces
  flutter pub get 2>/dev/null || true
fi

# Accept Android licenses
echo "⚖️  Accepting Android licenses..."
yes 2>/dev/null | flutter doctor --android-licenses || true

# Verify setup
echo "🔍 Verifying Flutter installation..."
flutter --version 2>/dev/null || echo "⚠️  Flutter version check failed"
flutter doctor 2>/dev/null || echo "⚠️  Flutter doctor had warnings (expected in container)"

echo ""
echo "✅ Flutter setup completed!"
echo ""
echo "📋 Quick start commands:"
echo "  flutter run           - Run app on device/emulator"
echo "  flutter build apk     - Build Android APK"
echo "  flutter test          - Run tests"
echo "  make help             - View all available commands"
echo ""
