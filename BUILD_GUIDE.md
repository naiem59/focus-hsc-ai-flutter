# Build Guide - Focus HSC AI Flutter App

## Prerequisites

Before you start, ensure you have:

1. **Flutter Environment**
   - Flutter SDK: 3.10.0 or higher
   - Dart: 3.0.0 or higher
   - Android Studio or VS Code with Flutter extension

2. **System Requirements**
   - For Android: Android SDK level 21+
   - For iOS: iOS 11+
   - RAM: 4GB minimum, 8GB recommended
   - Disk space: 2GB

3. **API Keys**
   - Gemini API Key (from Google AI Studio)

## Step-by-Step Setup

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd focus-hsc-ai-flutter
```

### Step 2: Get Flutter Dependencies

```bash
flutter pub get
```

This downloads all required packages including:
- riverpod (state management)
- dio (HTTP client)
- hive (local database)
- shared_preferences
- google_fonts
- flutter_animate

### Step 3: Generate Code (Build Runner)

Some packages require code generation:

```bash
flutter pub run build_runner build
```

This generates:
- Hive adapter files for type registration
- JSON serialization code

### Step 4: Configure API Key

#### Option A: Local Configuration (Development)

1. Create `lib/secrets.dart` file:

```dart
class Secrets {
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
}
```

2. Update `lib/constants/app_constants.dart`:

```dart
import '../secrets.dart';

static const String geminiApiKey = Secrets.geminiApiKey;
```

#### Option B: Environment Variables (Recommended)

1. Create `.env` file in project root:

```
GEMINI_API_KEY=your_api_key_here
```

2. Add dependency to pubspec.yaml:

```yaml
dependencies:
  flutter_dotenv: ^5.0.0
```

3. Load in main.dart:

```dart
await dotenv.load();
```

### Step 5: Run the App

#### Android

```bash
flutter run -d <device-id>
```

Or without specifying device (launches on connected device):

```bash
flutter run
```

#### iOS

```bash
flutter run -d <device-id>
cd ios
pod install
cd ..
flutter run
```

#### Web

```bash
flutter run -d chrome
```

### Step 6: Build for Production

#### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS

```bash
flutter build ios --release
```

Then use Xcode to create an IPA:

```bash
open ios/Runner.xcworkspace
```

## Project Configuration

### Pubspec.yaml Key Sections

```yaml
# App metadata
name: focus_hsc_ai
version: 1.0.0+1

# Minimum SDK versions
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"

# Dependencies
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  dio: ^5.3.0
  hive: ^2.2.0
  shared_preferences: ^2.2.0
  google_fonts: ^6.1.0
  
# Dev dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  hive_generator: ^2.0.0

# Assets
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/data/subjects.json
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
```

## Troubleshooting

### Issue: Build failures

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
flutter run
```

### Issue: API key not working

**Solution:**
1. Verify key is valid in Google AI Studio
2. Check API quota hasn't been exceeded
3. Ensure internet connection is active
4. Try regenerating the key

### Issue: Hive database errors

**Solution:**
```dart
// In services/local_storage_service.dart
await Hive.deleteBoxFromDisk('box_name');
// Then restart the app
```

### Issue: Slow build times

**Solution:**
```bash
# Use release mode during development
flutter run --release

# Or use split debug info
flutter run --split-debug-info=./symbols
```

## Development Workflow

### Adding a New Screen

1. Create file: `lib/screens/new_screen.dart`
2. Create state provider: `lib/providers/new_provider.dart`
3. Add route in `lib/main.dart`
4. Create widgets in `lib/widgets/` if needed

### Adding a New Model

1. Create file: `lib/models/new_model.dart`
2. If using Hive:
   ```dart
   @HiveType(typeId: X)
   class NewModel extends HiveObject {
       @HiveField(0)
       late String id;
   }
   ```
3. Register adapter in `local_storage_service.dart`
4. Run: `flutter pub run build_runner build`

### Testing

Run tests with:
```bash
flutter test
```

## Performance Tips

1. **Use const constructors** wherever possible
2. **Lazy load images** using Image.network with caching
3. **Limit API calls** - cache responses locally
4. **Use PageView** for screen transitions
5. **Profile with DevTools**:
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

## Deployment Checklist

Before release:

- [ ] Remove debug prints
- [ ] Verify API key is production key
- [ ] Test on multiple devices
- [ ] Check app size
- [ ] Review all error handling
- [ ] Update version in pubspec.yaml
- [ ] Create build signing key
- [ ] Test offline functionality
- [ ] Review privacy policy
- [ ] Check app permissions

## Publishing to App Stores

### Google Play Store

1. Create Google Play Developer account
2. Sign APK with production key:
   ```bash
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
     -keystore my-release-key.keystore \
     app-release-unsigned.apk \
     alias_name
   ```
3. Upload to Play Store Console

### Apple App Store

1. Create Apple Developer account
2. Create App ID in Apple Developer Portal
3. Build and archive in Xcode
4. Upload via Transporter or Xcode

## Support

For issues during build:
- Check Flutter version: `flutter --version`
- Check Android SDK: `flutter doctor`
- Review logs: `flutter run -v`
- Check GitHub issues: [link]
- Contact support: support@focushsc.ai

---

**Last Updated**: May 8, 2026
**Flutter Version**: 3.10.0+
