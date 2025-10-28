#!/bin/bash

# Habit Rabbit - Development automation script
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🐰 Habit Rabbit - $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

show_help() {
    echo ""
    echo "Usage: ./run.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  setup                   - Install dependencies"
    echo "  clean                   - Clean build artifacts"
    echo "  run                     - Run the app"
    echo "  run-release             - Run in release mode"
    echo "  run-device [device_id]  - Run on specific device"
    echo "  analyze                 - Run code analysis"
    echo "  format                  - Format code"
    echo "  test                    - Run tests"
    echo "  build-apk               - Build Android APK"
    echo "  build-aab               - Build Android App Bundle"
    echo "  build-ios               - Build iOS app"
    echo "  build-web               - Build web version"
    echo "  upgrade-deps            - Upgrade dependencies"
    echo "  help                    - Show this help message"
    echo ""
}

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
}

# Commands
setup() {
    print_header "Setup - Installing Dependencies"
    check_flutter
    
    if flutter pub get; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

clean() {
    print_header "Cleaning"
    check_flutter
    
    flutter clean
    rm -rf build/
    rm -rf .dart_tool/
    rm -rf pubspec.lock
    
    print_success "Clean complete"
}

run() {
    print_header "Running App"
    check_flutter
    
    flutter run
}

run_release() {
    print_header "Running App - Release Mode"
    check_flutter
    
    flutter run --release
}

run_device() {
    local device_id=$1
    
    if [ -z "$device_id" ]; then
        print_header "Available Devices"
        flutter devices
        print_warning "Please specify device: ./run.sh run-device <device_id>"
        exit 1
    fi
    
    print_header "Running App - Device: $device_id"
    check_flutter
    
    flutter run -d "$device_id"
}

run_verbose() {
    print_header "Running App - Verbose Mode"
    check_flutter
    
    flutter run -v
}

analyze() {
    print_header "Code Analysis"
    check_flutter
    
    if flutter analyze; then
        print_success "Code analysis passed"
    else
        print_error "Code analysis failed"
        exit 1
    fi
}

format() {
    print_header "Formatting Code"
    check_flutter
    
    dart format lib/ test/ --line-length 80
    print_success "Code formatted"
}

format_check() {
    print_header "Checking Code Format"
    check_flutter
    
    if dart format lib/ test/ --line-length 80 --set-exit-if-changed; then
        print_success "Code format check passed"
    else
        print_error "Code format check failed"
        exit 1
    fi
}

test() {
    print_header "Running Tests"
    check_flutter
    
    flutter test
}

upgrade_deps() {
    print_header "Upgrading Dependencies"
    check_flutter
    
    flutter pub upgrade
    print_success "Dependencies upgraded"
}

build_apk() {
    print_header "Building Android APK"
    check_flutter
    
    if flutter build apk --release; then
        print_success "APK built successfully"
        echo "Location: build/app/outputs/flutter-apk/app-release.apk"
    else
        print_error "Failed to build APK"
        exit 1
    fi
}

build_aab() {
    print_header "Building Android App Bundle"
    check_flutter
    
    if flutter build appbundle --release; then
        print_success "App Bundle built successfully"
        echo "Location: build/app/outputs/bundle/release/app-release.aab"
    else
        print_error "Failed to build App Bundle"
        exit 1
    fi
}

build_ios() {
    print_header "Building iOS App"
    check_flutter
    
    if flutter build ios --release; then
        print_success "iOS app built successfully"
    else
        print_error "Failed to build iOS app"
        exit 1
    fi
}

build_web() {
    print_header "Building Web App"
    check_flutter
    
    if flutter build web --release; then
        print_success "Web app built successfully"
        echo "Location: build/web/"
    else
        print_error "Failed to build web app"
        exit 1
    fi
}

pod_install() {
    print_header "Installing iOS Pods"
    
    cd ios || exit 1
    
    if pod install; then
        print_success "Pods installed successfully"
    else
        print_error "Failed to install pods"
        exit 1
    fi
    
    cd ..
}

check_all() {
    print_header "Running All Checks"
    
    format_check && analyze && print_success "All checks passed!"
}

# Main
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    setup)
        setup
        ;;
    clean)
        clean
        ;;
    run)
        run
        ;;
    run-release)
        run_release
        ;;
    run-verbose)
        run_verbose
        ;;
    run-device)
        run_device "$2"
        ;;
    analyze)
        analyze
        ;;
    format)
        format
        ;;
    format-check)
        format_check
        ;;
    test)
        test
        ;;
    upgrade-deps)
        upgrade_deps
        ;;
    build-apk)
        build_apk
        ;;
    build-aab)
        build_aab
        ;;
    build-ios)
        build_ios
        ;;
    build-web)
        build_web
        ;;
    pod-install)
        pod_install
        ;;
    check)
        check_all
        ;;
    help)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
