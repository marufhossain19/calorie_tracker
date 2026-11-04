# 🥑 CalTrack — Precision Daily Calorie & Nutrition Tracker

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-00C853?style=for-the-badge)](https://blog.cleancoder.com)
[![State Management](https://img.shields.io/badge/State-Provider-FF6F00?style=for-the-badge)](https://pub.dev/packages/provider)
[![Theme](https://img.shields.io/badge/Theme-Dual%20Mode-B8F624?style=for-the-badge&labelColor=0F172A)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

A production-grade, beautifully crafted Flutter mobile application designed for tracking daily calorie consumption with surgical accuracy. Engineered with **Clean Architecture**, a cohesive **Dual-Theme Design System** (Deep Black `#05070A` & Daylight White `#F8FAFC`), fluid **Lottie micro-interactions**, and automatic meal segmentation.

---

## 📥 Download Application (APK)

> **Test and explore CalTrack directly on your Android device:**
> 
> 📦 **[Download CalTrack APK (Google Drive) 📥](https://drive.google.com/file/d/1n3QEC6duYtFJkp1G0wKT_SmgSUW4FvzU/view?usp=sharing)**
> 
> Direct release build ready for immediate installation on Android devices.

---

## 📋 Requirements & Implementation Status

| Feature / Module | Specification | Status | Highlights |
| :--- | :--- | :---: | :--- |
| **Clean Architecture** | Separation of Core, Data, Domain, Presentation | `✅ Implemented` | Independent use cases, repository pattern & clean decoupling |
| **Dual Theme System** | Deep Black (`#05070A`) & Daylight White (`#F8FAFC`) | `✅ Implemented` | Instant toggle, zero-latency repaint, strict WCAG contrast |
| **Onboarding Flow** | Splash animation, Name Input, Drum Wheel Goal Picker | `✅ Implemented` | Smooth Lottie transitions, 50 kcal increments, quick presets |
| **Home Dashboard** | Calorie balance, dynamic progress, meal stats | `✅ Implemented` | 180° semi-circular gauge with orbiting dynamic tip pill |
| **Automatic Meal Intake** | Time-based classification into Breakfast, Lunch, Dinner | `✅ Implemented` | 4 AM–12 PM (Breakfast), 12 PM–6 PM (Lunch), 6 PM–4 AM (Dinner) |
| **Meals Breakdown** | 3 sub-cards for consumed meal calories | `✅ Implemented` | Dedicated live counters for Breakfast, Lunch, and Dinner |
| **Authentic Food Catalog** | 15 authentic dishes with realistic nutrition data | `✅ Implemented` | High-res dish photography, search bar, and category filters |
| **Custom Food Creation** | Add custom dishes with image from device gallery | `✅ Implemented` | Form validation, calorie verification, gallery integration |
| **Dish Details Screen** | Dedicated dish showcase with calorie impact ring | `✅ Implemented` | Hero image, macro pills, and one-tap meal logging |
| **Weekly Analytics** | Bar chart tracking 7-day intake vs. daily goal | `✅ Implemented` | Clean bars, average intake, target hit rate, zero clutter |
| **Profile & Settings** | Target modification, member badge, theme toggle | `✅ Implemented` | Inline drum picker modal for updating daily calorie target |
| **Testing Suite** | Unit, domain, widget, and state disposal tests | `✅ Implemented` | 100% test pass rate across 7 test suites |

---

## 📸 App Screenshots & User Experience

### 1. Onboarding & Personalization
| Welcome & Splash | Name Input | Target Calorie Setup |
| :---: | :---: | :---: |
| <img src="lib/Outputs_Screen/Get%20Started%20Screen.png" width="260" alt="Get Started Screen" /> | <img src="lib/Outputs_Screen/Enter%20name%20screen.png" width="260" alt="Enter Name Screen" /> | <img src="lib/Outputs_Screen/Setup%20Target%20calorie.png" width="260" alt="Target Setup Screen" /> |
| *Walking Avocado Lottie entrance* | *Centered field with interactive avatar* | *Interactive 50 kcal drum picker* |

<br/>

### 2. Home Dashboard (Dual Theme System)
| Deep Black Mode (Default) | Daylight White Mode |
| :---: | :---: |
| <img src="lib/Outputs_Screen/home%20screen.png" width="320" alt="Home Screen Dark" /> | <img src="lib/Outputs_Screen/home%20screen%20in%20light%20mode.png" width="320" alt="Home Screen Light" /> |
| *Deep Black `#05070A` with `#B8F624` Lime accents* | *Daylight White `#F8FAFC` with high-contrast slate* |

<br/>

### 3. Food Catalog, Intake & Custom Dish Creation
| Food Catalog Screen | Dish Details Screen | Add Custom Food Item |
| :---: | :---: | :---: |
| <img src="lib/Outputs_Screen/Food%20List%20screen.png" width="260" alt="Food List Screen" /> | <img src="lib/Outputs_Screen/Food%20details%20screen.png" width="260" alt="Food Details Screen" /> | <img src="lib/Outputs_Screen/add%20food%20item%20screen.png" width="260" alt="Add Food Screen" /> |
| *15 Authentic dishes with quick filters* | *Clean hero photo with calorie ring* | *Device gallery picker & validation* |

<br/>

### 4. Weekly Analytics & Profile Management
| Analytics & Weekly Trends | Profile & Target Management |
| :---: | :---: |
| <img src="lib/Outputs_Screen/analytics%20screen.png" width="320" alt="Analytics Screen" /> | <img src="lib/Outputs_Screen/profile%20screen.png" width="320" alt="Profile Screen" /> |
| *Minimalist weekly bar chart vs. daily target* | *Profile details with target editor & theme switch* |

---

## ✨ Key Features

- **Semi-Circular Radial Progress Gauge**: Custom canvas geometry rendering a 180° arch with 33 radial tick marks and an orbiting dynamic percentage pill that tracks along the circumference without overlapping.
- **Smart Time-Based Meal Categorization**: Automatically classifies logged meals based on the intake timestamp:
  - **Breakfast**: `4:00 AM – 11:59 AM`
  - **Lunch**: `12:00 PM – 5:59 PM`
  - **Dinner**: `6:00 PM – 3:59 AM`
- **Meals Breakdown Card**: Live 3-column breakdown on the dashboard displaying exact calories consumed during Breakfast, Lunch, and Dinner.
- **Verified Nutrition Catalog**: Preloaded authentic dishes (Biriyani, Beef Curry, Boiled Egg, Khichuri, Rice, Fish Curry, Omlet, Lentil Curry, etc.) with accurate caloric values and high-res photography.
- **Interactive Drum Wheel Pickers**: High-precision Cupertino-style physics pickers for selecting daily targets (`1,200 – 4,000 kcal` in `50 kcal` steps).
- **Lottie Vector Micro-Animations**:
  - `Walking Avocado.json` on the splash screen for brand identity.
  - `enter name.json` interactive avatar on the name input screen.
  - `Food Choice.json` for empty state feedback on meals.
- **Robust In-Memory State**: Responsive reactive state management with `Provider`, with undo/delete SnackBar feedback and safe disposal lifecycles.

---

## 🛠 Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Channel stable, ^3.13+)
- **Language**: [Dart](https://dart.dev)
- **Architecture**: **Clean Architecture**
  - **Domain**: Entities (`FoodItemEntity`, `UserProfileEntity`), Use Cases (`AddFoodItemUseCase`, `GetDailyLogsUseCase`, etc.), Repository contracts.
  - **Data**: Models, Local in-memory datasources, Repository implementations.
  - **Presentation**: State controllers (`CalorieTrackerController`, `UserController`), reusable atomic widgets, feature screens.
- **State Management**: `Provider` (ChangeNotifier)
- **Asset Integrations**: `lottie: ^3.8.2`, `image_picker: ^1.2.4`, `cupertino_icons: ^1.0.8`

---

## 📁 Project Directory Structure

```text
calorie_tracker/
├── android/                        # Android native configurations & launcher icons
├── ios/                            # iOS native configurations & asset catalog
├── lib/
│   ├── core/                       # Core foundation & application constants
│   │   ├── constants/              # Design tokens (AppColors), FoodCatalog, AppConstants
│   │   ├── di/                     # Dependency Injection (Service Locator)
│   │   └── utils/                  # Date formatters & helpers
│   ├── data/                       # Data layer
│   │   ├── datasources/            # In-memory local datasources
│   │   ├── models/                 # Data transfer models (FoodItemModel, etc.)
│   │   └── repositories/           # Repository implementations
│   ├── domain/                     # Domain layer (pure business logic)
│   │   ├── entities/               # Core business models
│   │   ├── repositories/           # Repository interfaces
│   │   └── usecases/               # Granular use cases
│   ├── presentation/               # Presentation layer (UI & State)
│   │   ├── assets/                 # Dish photos & Lottie animation files
│   │   ├── controllers/            # CalorieTrackerController & UserController
│   │   ├── screens/                # Feature screens (Home, Food, Analytics, Profile, Onboarding)
│   │   └── widgets/                # Reusable UI widgets & bottom sheets
│   ├── Outputs_Screen/             # Output screenshot assets for documentation
│   └── main.dart                   # Application entry point
├── test/                           # Comprehensive test suite (Domain, Widget, Controllers)
└── pubspec.yaml                    # Package dependencies & asset declarations
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.13.0` or higher)
- [Dart SDK](https://dart.dev/get-dart) (`v3.0.0` or higher)
- Android Studio / VS Code with Flutter extension
- An Android Emulator or physical device

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/calorie_tracker.git
   cd calorie_tracker
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify static analysis:**
   ```bash
   flutter analyze
   ```

4. **Run test suite:**
   ```bash
   flutter test
   ```

5. **Run application on connected device:**
   ```bash
   flutter run
   ```

6. **Build release APK:**
   ```bash
   flutter build apk --release
   ```
   *The built APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`*

---

## 👨‍💻 Author & Acknowledgements

- **Developer**: Mobile Engineering Team
- **Project**: CalTrack — Precision Daily Calorie & Nutrition Tracker
- **License**: Distributed under the MIT License. See `LICENSE` for more information.
