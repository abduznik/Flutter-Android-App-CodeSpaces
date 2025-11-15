# Troubleshooting Guide

## Flutter Installation Issues

### Issue: "flutter: command not found"

This is the most common issue, especially on first setup or when the devcontainer hasn't rebuilt properly.

#### Cause

The current environment may be running **Alpine Linux** which uses musl libc, while Flutter binaries are compiled for **glibc** (used by Ubuntu/Debian). Trying to run glibc binaries on Alpine results in "required file not found" errors.

#### Solution: Rebuild the Dev Container

1. **In VS Code:**
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "rebuild container"
   - Select "Dev Containers: Rebuild Container"
   - Wait 5-10 minutes for the rebuild

2. **Via GitHub Codespaces Web UI:**
   - Go to https://github.com/codespaces
   - Click the "..." menu on your codespace
   - Select "Rebuild container"

3. **Via CLI (if connected to codespace):**
   ```bash
   gh codespace rebuild --codespace [codespace-name]
   ```

#### What Happens During Rebuild

The `.devcontainer/devcontainer.json` file tells the system to:
1. Use Ubuntu base image (glibc-based, compatible with Flutter)
2. Install Flutter SDK feature (latest version)
3. Install Java and Android features
4. Run `post-create.sh` script to configure everything

**Note:** The first rebuild takes 5-10 minutes. Subsequent rebuilds are faster.

### Issue: "Dart SDK binary not found" or "cannot execute: required file not found"

**Cause:** Running on Alpine Linux which is incompatible with Flutter's glibc binaries.

**Solution:** Follow the "Rebuild the Dev Container" steps above.

### Issue: "Flutter doctor shows [!] errors"

Some errors in `flutter doctor` are expected in a headless container environment:

- `❌ Android Studio` - Not needed for CLI development (use command line tools)
- `❌ Chrome / Chromium` - Not available in container (use physical device)
- `❌ Xcode / macOS toolchain` - Can't develop for iOS in this container

All these can be ignored if building for Android.

**Only critical errors are:**
- ❌ Android SDK - Must be installed
- ❌ Flutter SDK - Must be installed
- ❌ Connected device - Needed only to run/test app

### Verify Correct Setup

After rebuild, you should see:

```bash
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Linux, locale en_US.UTF-8)
[✓] Android toolchain - develop for Android devices (Android SDK version 35.x)
[!] Xcode - not installed (needed for iOS development)
[!] Chrome - not installed (needed for web development)
[✓] Connected device (emulator available)
[✓] Network resources
```

The `[✓]` checkmarks for Flutter and Android toolchain are what matter.

## Running the App

### Setup Emulator or Device

**Android Emulator:**
```bash
# List available emulators
emulator -list-avds

# Start an emulator
emulator -avd [emulator-name] &

# Check connected devices
flutter devices
```

**Android Device:**
```bash
# Enable USB debugging on your device
# Connect via USB
# Check if recognized
adb devices
```

### Build and Run

```bash
# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release

# Build for debug testing
flutter build apk --debug
```

## Using Make Commands

Convenient shortcuts via Makefile:

```bash
# View all commands
make help

# Get dependencies
make deps

# Run app
make run

# Build APK
make build-apk
make build-apk-release  # For Play Store

# Run tests
make test

# Clean build artifacts
make clean
```

## Environment Variables

If you need to set Android paths manually:

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

# Or for Flutter
export PATH="$HOME/flutter/bin:$PATH"
```

To make permanent, add to `~/.bashrc` or `~/.zshrc`:

```bash
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
echo 'export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bashrc
```

## Git and Development

### Check Status

```bash
git status          # See uncommitted changes
git log --oneline   # View commit history
```

### Track Dev Files

The `.gitignore` is configured to track development essentials:
- ✅ `pubspec.lock` - Dependency lock (DO commit)
- ✅ `.devcontainer/` - Container config (DO commit)
- ✅ `README.md`, `SETUP.md`, `*.md` docs (DO commit)
- ✅ `Makefile` - Development commands (DO commit)
- ❌ `.dart_tool/`, `build/`, `*.iml` - Build artifacts (DON'T commit)

### Commit Changes

```bash
# Add files
git add .

# Commit
git commit -m "feat: add new feature"

# Push
git push origin main
```

## Common Errors and Fixes

### Error: "Could not find Android SDK"

```bash
# Check Android SDK location
flutter doctor -v

# Set it manually
export ANDROID_HOME="$HOME/Android/Sdk"

# Or install it
flutter doctor --android-licenses
```

### Error: "Gradle error: Could not find method kotlin()"

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

### Error: "Device offline" or "adb not responding"

```bash
# Restart ADB
adb kill-server
adb start-server

# Check devices
adb devices
flutter devices

# Reconnect device or restart emulator
```

### Error: "APK installation failed"

```bash
# Uninstall previous version
adb uninstall com.example.my_app

# Rebuild and install
flutter install
```

## Performance Tips

### Speed Up Builds

```bash
# Use split APKs for faster builds
flutter build apk --split-per-abi

# Use release mode for real testing
flutter run --release
```

### Reduce Container Size

```bash
# Clean up
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Prune unused dependencies
flutter pub upgrade --dry-run
```

## Getting Help

### Inside Container

```bash
# Flutter help
flutter --help
flutter doctor -v

# Dart help
dart --help

# Gradle help (Android)
./gradlew --help
```

### External Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Android Development](https://developer.android.com/)
- [GitHub Codespaces Docs](https://docs.github.com/en/codespaces)

### Debugging

```bash
# View app logs
flutter logs

# Verbose output
flutter run -v
flutter doctor -v

# Attach debugger to running app
flutter attach
```

## Still Having Issues?

1. Check the creation logs: `.codespaces/.persistedshare/creation.log`
2. Run `flutter doctor -v` for detailed diagnosis
3. Try rebuilding the container (may take 10 minutes)
4. Delete and recreate the codespace as a last resort
