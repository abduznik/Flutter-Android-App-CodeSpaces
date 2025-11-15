# Flutter Development Setup Guide

Complete guide for setting up Flutter development environment and building Android apps.

## Table of Contents

1. [Conanirization & Containerization](#conanirization--containerization)
2. [Environment Setup](#environment-setup)
3. [Android Configuration](#android-configuration)
4. [Flutter Build Process](#flutter-build-process)
5. [Troubleshooting](#troubleshooting)
6. [Development Commands](#development-commands)

## Conanirization & Containerization

### What is Conanirization?

Conanirization refers to the process of creating a consistent, reproducible development environment using containers. In this project, we use GitHub Codespaces with a `.devcontainer` configuration to ensure all developers have identical environments.

### Devcontainer Setup

The `.devcontainer/devcontainer.json` file defines:
- Base image with Ubuntu 24.04 LTS
- Flutter SDK installation
- Android SDK setup
- Required tools and dependencies
- VS Code extensions for Flutter development

This ensures that when you create a new codespace, all necessary tools are automatically configured.

### Benefits of This Setup

✅ Consistent development environment across all machines
✅ No local machine pollution (no need to install tools locally)
✅ Easy onboarding for new developers
✅ Reproducible builds
✅ All dependencies tracked in version control

## Environment Setup

### Current Environment

```
OS: Ubuntu 24.04 LTS
Flutter SDK: 3.0+ (installed in devcontainer)
Dart SDK: 3.0+ (included with Flutter)
Android SDK: API 21-35 (configured in devcontainer)
Java: OpenJDK 17+ (installed in devcontainer)
```

### Verifying Installation

```bash
# Check Flutter installation
flutter --version

# Check Dart installation
dart --version

# Comprehensive environment check
flutter doctor

# Verbose diagnostics
flutter doctor -v
```

### Expected Output of `flutter doctor`

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Linux, locale en_US.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.x.x)
[✓] Linux toolchain - develop for Linux
[!] Android Studio (not installed)
[✓] VS Code (version 1.x)
[✓] Connected device (1 available)
[✓] Network resources
```

## Android Configuration

### Android SDK Structure

```
Android SDK Root: /home/vscode/Android/Sdk/
├── platforms/
│   ├── android-21/  # Min target
│   ├── android-33/
│   ├── android-34/
│   └── android-35/  # Latest stable
├── build-tools/
│   └── 35.x.x/
├── platform-tools/
│   └── adb, fastboot
├── tools/
├── emulator/
└── cmdline-tools/
```

### Gradle Configuration

Key files for Android build configuration:

- **`android/build.gradle.kts`** - Root Gradle configuration
- **`android/app/build.gradle.kts`** - App-specific configuration
- **`android/gradle.properties`** - Gradle properties (JVM memory, etc.)
- **`android/local.properties`** - Local machine configuration (generated)

### Android Manifest

Located at: `android/app/src/main/AndroidManifest.xml`

Key configurations:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.my_app">
    
    <uses-sdk
        android:minSdkVersion="21"
        android:targetSdkVersion="35" />
    
    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:supportsRtl="true"
        android:usesCleartextTraffic="false">
        <!-- Activity declarations -->
    </application>
</manifest>
```

### Building APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release

# App Bundle (for Google Play)
flutter build appbundle --release
```

Output locations:
- Debug APK: `build/app/outputs/apk/debug/app-debug.apk`
- Release APK: `build/app/outputs/apk/release/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

## Flutter Build Process

### Build Steps

1. **Get Dependencies**
   ```bash
   flutter pub get
   ```
   Reads `pubspec.yaml` and downloads packages listed in `pubspec.lock`

2. **Code Generation**
   ```bash
   flutter pub get
   ```
   Generates files like `build/generated/...`

3. **Build for Target**
   ```bash
   flutter build apk      # Android
   flutter build ios      # iOS
   flutter build web      # Web
   ```

4. **Sign (Release only)**
   ```bash
   # Uses signing config from android/app/build.gradle.kts
   flutter build apk --release
   ```

### Project Files

- **`pubspec.yaml`** - Project manifest (dependencies, metadata)
- **`pubspec.lock`** - Dependency lock file (ensures reproducibility)
- **`lib/main.dart`** - App entry point
- **`lib/`** - All Dart/Flutter source code

### Generated Files (Ignored)

These are generated during build and NOT committed:

- `.dart_tool/` - Build cache
- `build/` - Build outputs
- `.packages` - Package manifest
- `.flutter-plugins` - Plugin registry
- `*.iml` - IDE files

## Troubleshooting

### "Flutter command not found"

**Cause:** Flutter SDK not in PATH

**Solution:**
```bash
# Check if Flutter is installed
which flutter

# If not found, install via devcontainer rebuild
# Or manually set PATH:
export PATH="$HOME/flutter/bin:$PATH"
```

### "Android SDK not found"

**Cause:** Android SDK path not configured

**Solution:**
```bash
# Check Android SDK
flutter doctor

# If needed, set ANDROID_HOME
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
```

### Build Gradle Errors

**Common error:** `Error: Could not find method kotlin()`

**Solution:**
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Try building again
flutter build apk
```

### APK Installation Fails

**Error:** "Failure [INSTALL_FAILED_SIGNATURE_MISMATCH]"

**Cause:** Different signing keys between builds

**Solution:**
```bash
# Uninstall previous version
adb uninstall com.example.my_app

# Rebuild and install
flutter install
```

### Device Connection Issues

**Check device status:**
```bash
adb devices
flutter devices
```

**Troubleshoot:**
```bash
# Restart adb
adb kill-server
adb start-server

# Check device logs
flutter logs
```

## Development Commands

### Using Makefile (Recommended)

```bash
# View all commands
make help

# Get dependencies
make deps

# Build for Android
make build-apk        # Debug APK
make build-aab        # App Bundle (Play Store)

# Run app
make run              # On connected device

# Testing
make test             # Run tests
make test-watch       # Watch mode

# Maintenance
make clean            # Clean build artifacts
make doctor           # Run flutter doctor
make upgrade          # Upgrade Flutter and deps
make format           # Format Dart code
make analyze          # Static analysis
```

### Direct Flutter Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/

# Clean build
flutter clean
```

### Git Workflow

```bash
# Ensure dev files are not ignored
git status

# Track new development files
git add SETUP.md README.md .devcontainer/ Makefile

# Verify before commit
git diff --staged

# Commit with descriptive message
git commit -m "chore: add development setup documentation and devcontainer config"

# Push to repository
git push origin main
```

## CI/CD Integration (Optional)

To add automated builds, create `.github/workflows/flutter-build.yml`:

```yaml
name: Flutter Build

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
```

## Next Steps

1. ✅ Review this SETUP.md file
2. ✅ Run `flutter doctor` to verify environment
3. ✅ Run `flutter pub get` to get dependencies
4. ✅ Connect Android device/emulator
5. ✅ Run `flutter run` to test
6. ✅ Read CONTRIBUTING.md for code standards

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Android Development](https://developer.android.com/)
- [Dart Language](https://dart.dev/)
- [GitHub Codespaces Guide](https://docs.github.com/en/codespaces)

## Notes

- This setup is optimized for GitHub Codespaces
- All development happens in containers for consistency
- Don't commit generated build artifacts (see `.gitignore`)
- Always commit updated `pubspec.lock` file
- Keep Flutter and dependencies up to date with `flutter upgrade`
