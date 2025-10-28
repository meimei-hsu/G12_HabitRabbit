# Habit Rabbit 🐰

> A personalized keystone habit formation app powered by rule-based algorithm and behavioral science.

## 📱 Overview

**Habit Rabbit** leverages personality analysis theory to create customized habit formation plans tailored to each user's unique characteristics. We provide smart, targeted recommendations to help you achieve your goals effectively, focusing on building consistent exercise and meditation habits.

### ✨ Key Features

- 📌 **Smart Personalized Plans** - Algorithm-generated habit plans customized to your personality
- 👥 **Personality Classification** - 8 personality archetypes for targeted habit strategies
- 🎮 **Gamification System** - Track progress, earn rewards, and maintain motivation
- 📋 **Commitment Contracts** - Self-binding commitment contracts to enforce accountability

---

## 🚀 Getting Started

### Prerequisites

- **Flutter**: Version 3.0.0 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart**: Version 2.19.5 or higher (included with Flutter)
- **Firebase Project**: Set up Firebase for authentication and database
- **Android Studio** or **Xcode**: For Android/iOS development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/meimei-hsu/G12_HabitRabbit.git
   cd G12_HabitRabbit
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Android: Update `android/app/google-services.json`
   - iOS: Update `ios/Runner/GoogleService-Info.plist`
   - macOS: Update `macos/Runner/GoogleService-Info.plist`

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

For faster development, use the provided automation script:

```bash
# Using the Makefile
make setup
make run

# Or using the shell script
./run.sh setup
./run.sh run
```

---

## 📦 Dependencies

### Core Framework
- **flutter**: Flutter SDK
- **firebase_core**: Firebase initialization
- **firebase_auth**: User authentication
- **firebase_database**: Real-time database

### UI & Widgets
- **google_fonts**: Custom fonts
- **cupertino_icons**: iOS-style icons
- **flutter_snake_navigationbar**: Bottom navigation
- **table_calendar**: Calendar widget
- **dots_indicator**: Carousel indicators
- **animations**: Flutter animations

### Data & Storage
- **shared_preferences**: Local data persistence
- **intl**: Internationalization support

### Charts & Visualization
- **fl_chart**: Line, bar, and pie charts
- **percent_indicator**: Progress indicators
- **syncfusion_flutter_charts**: Advanced charting

### Notifications & Media
- **flutter_local_notifications**: Local push notifications
- **timezone**: Timezone handling
- **just_audio**: Audio playback
- **video_player**: Video playback

### State Management
- **provider**: State management

See `pubspec.yaml` for the complete dependency list with versions.

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_page.dart       # Home screen
│   ├── gamification_page.dart
│   ├── community_page.dart
│   ├── statistic_page.dart
│   ├── settings_page.dart
│   ├── habit_detail_page.dart
│   ├── contract_page.dart
│   ├── routes.dart          # Route definitions
│   └── ...
└── services/
    ├── authentication.dart   # Firebase authentication
    ├── database.dart         # Database operations
    ├── crud.dart            # CRUD utilities
    ├── notification.dart    # Notification service
    ├── plan_algo.dart       # Habit planning algorithm
    ├── page_data.dart       # Global state & data models
    └── firebase_options.dart # Firebase configuration

assets/
├── images/
├── audios/
└── videos/
```

### Architecture Overview

```
crud.dart
├── DB                       (General database operations)
└── JournalDB               (Journal-specific operations)

database.dart
├── Calendar                (Calendar utilities)
├── UserDB                  (User management)
├── ContractDB              (Contract management)
├── GamificationDB          (Gamification data)
├── PokeDB                  (Notification tracking)
├── HabitDB                 (Workout/meditation tracking)
├── PlanDB                  (Plan management)
├── Calculator              (Statistics)
├── DurationDB              (Duration tracking)
└── WeightDB                (Weight tracking)

plan_algo.dart
├── PlanAlgo                (Main algorithm execution)
├── WorkoutAlgorithm        (Workout planning)
└── MeditationAlgorithm     (Meditation planning)

page_data.dart
├── Data                    (Global state)
├── PlanData                (Planning page state)
├── HomeData                (Home page state)
├── SettingsData            (Settings page state)
├── StatData                (Statistics page state)
├── GameData                (Gamification state)
├── CommData                (Community page state)
└── FriendData              (Friend status state)

authentication.dart
├── FireAuth                (Firebase authentication)
└── Validate                (Input validation)

notification.dart           (Notification service)
```

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory (see `.env.example`):

```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key

# App Configuration
ENVIRONMENT=development
```

---

## 📱 Running the App

### Development
```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>

# Run with verbose output
flutter run -v
```

### Build for Release

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

---

## 🧪 Testing

### Code Analysis
```bash
# Analyze code with lint rules
flutter analyze

# Format code
dart format lib/ test/
```

### Run Tests
```bash
flutter test
```

---

## 📊 Code Quality

This project uses Flutter linting rules defined in `analysis_options.yaml`. Key practices:

- ✅ Following [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- ✅ Using `flutter_lints` for recommended patterns
- ✅ Consistent code formatting with Dart formatter
- ✅ Null safety enabled by default

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository** on GitHub
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Code Style Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) conventions
- Run `flutter format` before committing
- Run `flutter analyze` and fix any warnings
- Write meaningful commit messages

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: `pub get` fails
```bash
flutter pub cache clean
flutter pub get
```

**Issue**: iOS build fails
```bash
cd ios
rm -rf Pods Pod.lock
cd ..
flutter pub get
flutter run
```

**Issue**: Android build fails
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📞 Support & Contact

For issues, questions, or suggestions:
- 📧 Create an [issue](https://github.com/meimei-hsu/G12_HabitRabbit/issues) on GitHub
- 🔗 Check existing [discussions](https://github.com/meimei-hsu/G12_HabitRabbit/discussions)
