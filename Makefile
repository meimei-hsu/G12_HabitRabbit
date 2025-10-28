.PHONY: help setup clean run build analyze format test

help:
	@echo "🐰 Habit Rabbit - Available Commands"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make setup              - Install dependencies"
	@echo "  make clean              - Clean build artifacts and cache"
	@echo ""
	@echo "Development:"
	@echo "  make run                - Run the app in development mode"
	@echo "  make run-device         - Run on specific device (requires DEVICE_ID)"
	@echo "  make run-release        - Run the app in release mode"
	@echo ""
	@echo "Code Quality:"
	@echo "  make analyze            - Run Flutter analyzer (lint checks)"
	@echo "  make format             - Format code according to Dart style guide"
	@echo "  make test               - Run unit tests"
	@echo ""
	@echo "Building:"
	@echo "  make build-apk          - Build Android APK"
	@echo "  make build-aab          - Build Android App Bundle"
	@echo "  make build-ios          - Build iOS app"
	@echo "  make build-web          - Build web version"
	@echo ""
	@echo "Maintenance:"
	@echo "  make upgrade-deps       - Upgrade Flutter and dependencies"
	@echo "  make pub-get            - Get/update pub dependencies"
	@echo "  make pod-install        - Install iOS pods"
	@echo ""

setup: pub-get
	@echo "✅ Setup complete! Dependencies installed."

pub-get:
	@echo "📦 Getting Flutter dependencies..."
	flutter pub get

clean:
	@echo "🧹 Cleaning build artifacts..."
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/
	rm -rf pubspec.lock
	@echo "✅ Clean complete!"

run:
	@echo "🚀 Running Habit Rabbit app..."
	flutter run

run-device:
	@echo "📱 Running on device..."
	@if [ -z "$(DEVICE_ID)" ]; then \
		echo "⚠️  Please specify DEVICE_ID: make run-device DEVICE_ID=your_device_id"; \
		flutter devices; \
	else \
		flutter run -d $(DEVICE_ID); \
	fi

run-release:
	@echo "🚀 Running app in release mode..."
	flutter run --release

run-verbose:
	@echo "🚀 Running app with verbose output..."
	flutter run -v

analyze:
	@echo "🔍 Analyzing code..."
	flutter analyze
	@echo "✅ Analysis complete!"

format:
	@echo "🎨 Formatting code..."
	dart format lib/ test/ --line-length 80
	@echo "✅ Formatting complete!"

format-check:
	@echo "🎨 Checking code format..."
	dart format lib/ test/ --line-length 80 --set-exit-if-changed

test:
	@echo "🧪 Running tests..."
	flutter test
	@echo "✅ Tests complete!"

upgrade-deps:
	@echo "⬆️  Upgrading dependencies..."
	flutter pub upgrade
	@echo "✅ Upgrade complete!"

build-apk:
	@echo "🏗️  Building Android APK..."
	flutter build apk --release
	@echo "✅ APK built successfully!"

build-aab:
	@echo "🏗️  Building Android App Bundle..."
	flutter build appbundle --release
	@echo "✅ App Bundle built successfully!"

build-ios:
	@echo "🏗️  Building iOS app..."
	flutter build ios --release
	@echo "✅ iOS app built successfully!"

build-web:
	@echo "🏗️  Building web app..."
	flutter build web --release
	@echo "✅ Web app built successfully!"

pod-install:
	@echo "📦 Installing iOS pods..."
	cd ios && pod install
	@echo "✅ Pods installed!"

pod-update:
	@echo "⬆️  Updating iOS pods..."
	cd ios && pod update
	@echo "✅ Pods updated!"

check: format-check analyze
	@echo "✅ All checks passed!"

all: clean setup analyze format test
	@echo "✅ All tasks completed!"
