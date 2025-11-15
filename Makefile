.PHONY: help clean deps build-apk build-aab build-ios build-web run test test-watch doctor upgrade format analyze logs

# Default target
.DEFAULT_GOAL := help

# Colors for output
YELLOW := \033[0;33m
GREEN := \033[0;32m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)Flutter Android App - Development Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Usage: make [target]$(NC)"
	@echo ""
	@echo "$(GREEN)Build Commands:$(NC)"
	@grep -E '(build-apk|build-aab|build-ios|build-web).*:' Makefile | sed 's/:.*##/ ##/' | column -t -s '##'
	@echo ""
	@echo "$(GREEN)Development Commands:$(NC)"
	@grep -E '(run|test|deps|clean|doctor|upgrade|logs).*:' Makefile | sed 's/:.*##/ ##/' | column -t -s '##'
	@echo ""
	@echo "$(GREEN)Code Quality Commands:$(NC)"
	@grep -E '(format|analyze).*:' Makefile | sed 's/:.*##/ ##/' | column -t -s '##'
	@echo ""

## Build Commands

build-apk: ## Build Android APK (debug)
	flutter build apk --debug

build-apk-release: ## Build Android APK (release)
	flutter build apk --release

build-aab: ## Build Android App Bundle (Play Store)
	flutter build appbundle --release

build-ios: ## Build iOS app
	flutter build ios

build-web: ## Build web app
	flutter build web

## Development Commands

run: ## Run app on connected device or emulator
	flutter run

run-release: ## Run app in release mode
	flutter run --release

test: ## Run all tests
	flutter test

test-watch: ## Run tests in watch mode
	flutter test --watch

deps: ## Get Flutter dependencies
	flutter pub get

clean: ## Clean build artifacts and cache
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/

doctor: ## Run flutter doctor (check environment)
	flutter doctor -v

upgrade: ## Upgrade Flutter and dependencies
	flutter upgrade
	flutter pub upgrade

## Code Quality

format: ## Format Dart code
	dart format lib/ test/

analyze: ## Run static analysis
	flutter analyze

## Logging & Debugging

logs: ## Show Flutter app logs
	flutter logs

logs-verbose: ## Show verbose Flutter logs
	flutter logs -v

## Convenience Commands

install-debug: build-apk ## Build and install debug APK
	adb install -r build/app/outputs/apk/debug/app-debug.apk

install-release: build-apk-release ## Build and install release APK
	adb install -r build/app/outputs/apk/release/app-release.apk

devices: ## List connected devices
	flutter devices

emulator-list: ## List available Android emulators
	emulator -list-avds

# Internal command - not shown in help
check-env: ## Check if all required tools are available
	@echo "Checking environment..."
	@which flutter > /dev/null && echo "✓ Flutter found" || echo "✗ Flutter not found"
	@which dart > /dev/null && echo "✓ Dart found" || echo "✗ Dart not found"
	@which adb > /dev/null && echo "✓ ADB found" || echo "✗ ADB not found"
	@which java > /dev/null && echo "✓ Java found" || echo "✗ Java not found"

# Internal - print help on invalid target
.PHONY: invalid
invalid:
	@echo "Invalid target. Use 'make help' to see available commands."
