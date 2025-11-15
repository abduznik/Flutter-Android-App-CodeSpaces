# Flutter Android App - Development Guide

A Flutter application with Android native integration, set up for development in GitHub Codespaces.

## Quick Start

### Prerequisites
- Flutter SDK (included in codespace setup)
- Android SDK (included in codespace setup)
- Java Development Kit (included in codespace setup)

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/abduznik/Flutter-Android-App-CodeSpaces.git
cd Flutter-Android-App-CodeSpaces

# Get Flutter dependencies
flutter pub get

# Build the app
make build-apk
# or for specific platforms
make build-ios    # iOS
make build-web    # Web
```

## Project Structure

```
├── android/           # Android native code and configuration
├── ios/               # iOS native code and configuration
├── lib/               # Dart/Flutter source code
├── test/              # Flutter tests
├── pubspec.yaml       # Flutter project configuration
└── pubspec.lock       # Dependency lock file (git-tracked)
```

## Available Commands

Run `make help` to see all available development commands:

```bash
make help           # Show all available commands
make build-apk      # Build Android APK
make build-aab      # Build Android App Bundle
make run            # Run the app on connected device
make test           # Run Flutter tests
make clean          # Clean build artifacts
make doctor         # Run flutter doctor
make upgrade        # Upgrade Flutter and dependencies
```

## Documentation

- **SETUP.md** - Complete setup and configuration guide
- **ARCHITECTURE.md** - App architecture and design decisions
- **CONTRIBUTING.md** - Contribution guidelines

## Development Workflow

### Running on Android Device/Emulator

```bash
# Start Android emulator
emulator -avd MyVirtualDevice &

# Run the app
flutter run

# Or build and install APK manually
flutter build apk
adb install -r build/app/outputs/apk/release/app-release.apk
```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Hot Reload

During development, use hot reload for faster iteration:

```bash
flutter run

# In the Flutter terminal, press 'r' for hot reload
# Press 'R' for hot restart
```

## Troubleshooting

### Flutter Doctor Issues

Run `flutter doctor` to diagnose setup issues:

```bash
flutter doctor
flutter doctor -v  # Verbose output
```

### Android Build Issues

```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Rebuild
flutter build apk
```

### Codespace Setup Issues

Refer to **SETUP.md** for detailed troubleshooting steps and conanirization notes.

## Environment Information

- **Framework:** Flutter 3.0+
- **Language:** Dart 3.0+
- **Android Target:** API Level 21+
- **iOS Target:** iOS 11+

## Contributing

See **CONTRIBUTING.md** for guidelines on:
- Code style
- Commit messages
- Pull request process
- Testing requirements

## License

Specify your license here.
