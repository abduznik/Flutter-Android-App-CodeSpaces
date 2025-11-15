#!/usr/bin/env bash
set -euo pipefail

HELP="Usage: $0 [debug|release]  (default: debug)"
BUILD_TYPE="${1:-debug}"

if ! command -v flutter >/dev/null 2>&1; then
  echo "[build_apk] flutter not found. Run 'scripts/setup_env.sh' inside the container first."
  exit 1
fi

if [ "$BUILD_TYPE" != "debug" ] && [ "$BUILD_TYPE" != "release" ]; then
  echo "$HELP"
  exit 1
fi

echo "[build_apk] Running 'flutter pub get'..."
flutter pub get

echo "[build_apk] Building APK (type: $BUILD_TYPE)"
if [ "$BUILD_TYPE" = "release" ]; then
  flutter build apk --release
else
  flutter build apk --debug
fi

echo "[build_apk] Done. APKs (if created) are in: build/app/outputs/flutter-apk/"
ls -la build/app/outputs/flutter-apk || true
