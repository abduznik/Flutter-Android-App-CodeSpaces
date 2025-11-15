#!/usr/bin/env bash
set -euo pipefail

echo "[setup_env] Checking environment..."

# Check Flutter
if ! command -v flutter >/dev/null 2>&1; then
  echo "[setup_env] flutter not found on PATH."
  if [ -d "$HOME/flutter" ]; then
    echo "[setup_env] Found Flutter at $HOME/flutter — adding to PATH for this run."
    export PATH="$HOME/flutter/bin:$PATH"
  else
    echo "[setup_env] No Flutter installation detected in container."
    echo "[setup_env] The devcontainer's post-create script should install Flutter automatically." 
    echo "[setup_env] To install manually run the devcontainer post-create or follow SETUP.md."
    exit 0
  fi
else
  echo "[setup_env] flutter found: $(command -v flutter)"
fi

# Android SDK root
SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
if [ -d "$SDK_ROOT" ]; then
  echo "[setup_env] Android SDK detected at: $SDK_ROOT"
else
  echo "[setup_env] Android SDK not found at $SDK_ROOT." 
  echo "[setup_env] The devcontainer post-create should install cmdline-tools and platforms; otherwise follow SETUP.md." 
  exit 0
fi

# Ensure sdkmanager is available (cmdline-tools)
if command -v sdkmanager >/dev/null 2>&1; then
  echo "[setup_env] sdkmanager is available on PATH"
else
  CMDLINE="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
  if [ -x "$CMDLINE" ]; then
    export PATH="$SDK_ROOT/cmdline-tools/latest/bin:$PATH"
    echo "[setup_env] Added cmdline-tools sdkmanager to PATH"
  else
    echo "[setup_env] sdkmanager not found; skipping SDK package checks."
    exit 0
  fi
fi

echo "[setup_env] Accepting SDK licenses (if any)..."
yes | sdkmanager --sdk_root="$SDK_ROOT" --licenses >/dev/null || true

echo "[setup_env] Ensuring required Android SDK packages are installed (platform-tools, android-33, build-tools 33.0.2)"
sdkmanager --sdk_root="$SDK_ROOT" "platform-tools" "platforms;android-33" "build-tools;33.0.2" || true

echo "[setup_env] Running 'flutter pub get' to ensure dependencies are fetched"
flutter pub get || true

echo "[setup_env] Environment check complete."

exit 0
