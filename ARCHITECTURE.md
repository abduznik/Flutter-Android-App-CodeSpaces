# Architecture Guide

This document describes the architecture and design decisions for the Flutter Android App.

## Project Structure

```
Flutter-Android-App-CodeSpaces/
├── .devcontainer/              # Codespace configuration
│   ├── devcontainer.json       # Container setup
│   └── post-create.sh          # Initialization script
├── android/                    # Android-specific code
│   ├── app/                    # App module
│   │   ├── src/
│   │   │   └── main/
│   │   │       ├── AndroidManifest.xml
│   │   │       ├── java/       # Kotlin/Java code
│   │   │       └── res/        # Android resources
│   │   └── build.gradle.kts    # App build config
│   ├── build.gradle.kts        # Root build config
│   └── gradle/                 # Gradle wrapper
├── ios/                        # iOS-specific code
├── lib/                        # Dart/Flutter source code
│   └── main.dart              # App entry point
├── test/                       # Flutter widget tests
├── pubspec.yaml               # Flutter project manifest
├── pubspec.lock               # Dependency lock file
├── .gitignore                 # Git ignore rules
├── Makefile                   # Development commands
├── README.md                  # User guide
├── SETUP.md                   # Setup documentation
├── CONTRIBUTING.md            # Contribution guidelines
└── ARCHITECTURE.md            # This file
```

## Dart Project Structure (lib/)

Recommended structure for larger projects:

```
lib/
├── main.dart                  # App entry point
├── app/
│   ├── app.dart              # App widget
│   └── routes.dart           # Route definitions
├── models/
│   └── user.dart             # Data models
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   └── login/
│       ├── login_screen.dart
│       └── widgets/
├── widgets/
│   ├── common/               # Reusable widgets
│   └── buttons/
├── services/
│   ├── api_service.dart      # API calls
│   └── auth_service.dart     # Authentication
├── utils/
│   ├── constants.dart        # App constants
│   ├── extensions.dart       # Dart extensions
│   └── helpers.dart          # Helper functions
├── providers/                # State management
│   └── app_provider.dart
└── theme/
    └── app_theme.dart        # App theming
```

## Technology Stack

### Core
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **Build System**: Gradle (Android), Xcode (iOS)

### Android
- **Min SDK**: API Level 21 (Android 5.0)
- **Target SDK**: API Level 35 (Android 15)
- **Build Tools**: 35.x.x
- **Java**: OpenJDK 17+
- **Kotlin Support**: Available

### Development
- **VCS**: Git
- **CI/CD Ready**: GitHub Actions
- **Container**: Docker (dev container)
- **IDE**: VS Code with Flutter extensions

## Build System

### Gradle Architecture

```
Root build.gradle.kts (android/build.gradle.kts)
└── plugins and shared configurations

App build.gradle.kts (android/app/build.gradle.kts)
├── android block (SDK config)
├── dependencies block (libraries)
└── buildTypes block (debug/release configs)
```

### Build Variants

**Debug Build** (development):
- Unoptimized for faster builds
- Debuggable
- Includes debugging symbols
- Unsigned APK

**Release Build** (production):
- Optimized for size and performance
- Not debuggable
- Proguard/R8 obfuscation enabled
- Requires signing key

## State Management Options

### Simple Projects
Use Flutter's built-in `setState()`:

```dart
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Count: $count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => count++),
      ),
    );
  }
}
```

### Medium-Large Projects
Consider using Provider or GetX:

```dart
// Using Provider
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(home: HomePage()),
    );
  }
}
```

## Navigation

### Basic Named Routes

```dart
// Define routes in main.dart
routes: {
  '/': (context) => HomePage(),
  '/login': (context) => LoginPage(),
  '/profile': (context) => ProfilePage(),
},

// Navigate
Navigator.pushNamed(context, '/profile');
```

### With Arguments

```dart
// Navigate with data
Navigator.pushNamed(
  context,
  '/profile',
  arguments: userId,
);

// Receive in target
final userId = ModalRoute.of(context)!.settings.arguments as String;
```

## Asset Organization

```
assets/
├── images/
│   ├── png/
│   ├── svg/
│   └── icons/
├── fonts/
│   └── custom_font.ttf
├── data/
│   ├── json/
│   └── csv/
└── animations/
    └── lottie/
```

Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/data/json/
    
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/custom_font.ttf
```

## Dependency Management

### pubspec.yaml Best Practices

1. **Version Constraints**: Use meaningful version ranges
   ```yaml
   cupertino_icons: ^1.0.2    # ^ allows compatible updates
   http: ~1.1.0               # ~ allows patch updates only
   ```

2. **Dev Dependencies**: Keep separate
   ```yaml
   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^2.0.0
   ```

3. **Keep Lock File**: Always commit `pubspec.lock`
   - Ensures reproducible builds
   - Required in `.gitignore` is NOT present

### Updating Dependencies

```bash
# Check for updates
flutter pub upgrade --dry-run

# Update to latest
flutter pub upgrade

# Update specific package
flutter pub upgrade http

# Get without updating
flutter pub get
```

## Android Kotlin Integration

For advanced native features:

```kotlin
// android/app/src/main/kotlin/com/example/my_app/MainActivity.kt
package com.example.my_app

import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // Custom Android code
}
```

### Platform Channels

Call Android code from Flutter:

```dart
// Flutter side
const platform = MethodChannel('com.example.my_app/native');

final String result = await platform.invokeMethod('getNativeData');
```

```kotlin
// Android side
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.my_app/native")
    .setMethodCallHandler { call, result ->
        when (call.method) {
            "getNativeData" -> result.success("Native data")
            else -> result.notImplemented()
        }
    }
```

## Error Handling

### Try-Catch Pattern

```dart
Future<void> loadData() async {
  try {
    final data = await apiService.fetchData();
    setState(() => this.data = data);
  } on ApiException catch (e) {
    showErrorDialog('API Error: ${e.message}');
  } on Exception catch (e) {
    showErrorDialog('Unexpected error: $e');
  }
}
```

### Future Error Handling

```dart
future.then(
  (data) => print('Success: $data'),
  onError: (error) => print('Error: $error'),
);
```

## Performance Considerations

### Widget Performance

1. **Use const constructors**
   ```dart
   const SizedBox(height: 16);  // ✓ Const
   SizedBox(height: 16);        // ✗ Rebuilds unnecessarily
   ```

2. **Avoid rebuilds with RepaintBoundary**
   ```dart
   RepaintBoundary(
     child: ExpensiveWidget(),
   );
   ```

3. **Use ListView.builder for long lists**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemTile(items[index]),
   );
   ```

### Image Optimization

```dart
// Cached images
Image.network(
  url,
  cacheWidth: 200,
  cacheHeight: 200,
);

// Use Image.asset for local images
Image.asset('assets/images/logo.png');
```

## Security Best Practices

1. **Never hardcode sensitive data**
   ```dart
   // ✗ Bad
   const String apiKey = 'sk_live_abc123xyz';
   
   // ✓ Good - Use environment variables or secure storage
   String apiKey = dotenv.env['API_KEY']!;
   ```

2. **Use https for API calls**
   ```dart
   final response = await http.get(
     Uri.https('api.example.com', '/endpoint'),
   );
   ```

3. **Validate user input**
   ```dart
   if (email.isEmpty || !email.contains('@')) {
     showError('Invalid email');
     return;
   }
   ```

## Testing Strategy

### Unit Tests

```dart
void main() {
  test('User name validation', () {
    expect(validateName('John'), true);
    expect(validateName(''), false);
  });
}
```

### Widget Tests

```dart
void main() {
  testWidgets('Login button works', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
  });
}
```

## Debugging

### Hot Reload During Development

```bash
flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart
```

### Debugging Tools

```bash
# Enable verbose logging
flutter run -v

# Start with debugger
flutter run --debug

# View device logs
flutter logs

# Connect to debugger
flutter attach
```

## Continuous Integration

See `.github/workflows/` for CI/CD setup. Example workflow file:
- Runs tests on every push
- Builds APK
- Generates reports
- Notifies on failures

## Future Enhancements

Potential improvements:
- [ ] Add state management library (Provider/GetX)
- [ ] Implement API client service
- [ ] Add Firebase integration
- [ ] Setup automated testing
- [ ] Add CI/CD pipeline
- [ ] Implement app analytics
- [ ] Add crash reporting
