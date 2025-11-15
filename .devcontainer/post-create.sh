#!/bin/bash
# Post-create script for Flutter Android development container

set -e

echo "🚀 Setting up Flutter Android development environment..."

# Update package lists
echo "📦 Updating package lists..."
apt-get update -qq

# Ensure Flutter is properly initialized
echo "✨ Initializing Flutter..."
flutter --version
flutter doctor

# Get project dependencies
echo "📚 Getting Flutter dependencies..."
cd /workspaces/Flutter-Android-App-CodeSpaces
flutter pub get

# Accept Android licenses
echo "⚖️  Accepting Android licenses..."
yes | flutter doctor --android-licenses || true

# Verify setup
echo "🔍 Verifying setup..."
flutter doctor -v

echo "✅ Flutter Android development environment is ready!"
echo ""
echo "📋 Quick start commands:"
echo "  flutter run           - Run app on device/emulator"
echo "  flutter build apk     - Build Android APK"
echo "  flutter test          - Run tests"
echo "  make help             - View all available commands"
echo ""
