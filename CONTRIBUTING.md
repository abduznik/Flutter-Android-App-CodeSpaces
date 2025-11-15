# Contributing to Flutter Android App

Thank you for your interest in contributing to this project! This document provides guidelines and standards for contributing.

## Code Style

### Dart Code Style

We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

```bash
# Format code automatically
make format

# Or manually
dart format lib/
```

Key conventions:
- Use 2-space indentation
- Use camelCase for variables and methods
- Use PascalCase for classes and types
- Use UPPER_CASE for constants

### Example

```dart
// ✓ Good
const String appTitle = 'My App';
final int userCount = 42;

class UserProfile {
  final String userName;
  
  UserProfile({required this.userName});
  
  void printName() {
    print('User: $userName');
  }
}

// ✗ Bad
const String AppTitle = 'My App';  // Should be camelCase
final int usercount = 42;  // Missing capital C
```

## Commit Messages

Use clear, descriptive commit messages following this format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring without changing functionality
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, dependencies, etc.

### Examples

```bash
git commit -m "feat(auth): add user login authentication"
git commit -m "fix(home): resolve null pointer exception in list view"
git commit -m "docs: update setup instructions"
git commit -m "style: format dart files"
git commit -m "test(auth): add login validation tests"
```

## Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit**
   ```bash
   git add .
   git commit -m "feat: add your feature"
   ```

3. **Test your changes**
   ```bash
   make test
   make analyze
   make format
   ```

4. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Create a Pull Request**
   - Write a clear PR title and description
   - Reference any related issues
   - Include screenshots or videos for UI changes

## Testing Requirements

All code changes should include tests:

```bash
# Run tests
make test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Writing Tests

```dart
void main() {
  group('UserProfile', () {
    test('userName getter returns correct name', () {
      final profile = UserProfile(userName: 'John');
      expect(profile.userName, 'John');
    });
    
    test('printName outputs user name', () {
      final profile = UserProfile(userName: 'Jane');
      expect(() => profile.printName(), prints('User: Jane\n'));
    });
  });
}
```

## Code Quality

### Static Analysis

Always run static analysis before committing:

```bash
make analyze
```

Fix any warnings or errors:

```dart
// ✓ Good - declare return type
String getName() => 'John';

// ✗ Bad - missing return type
var getName() => 'John';
```

### Documentation

Document your code with comments:

```dart
/// Authenticates user with email and password.
///
/// Returns a [User] object if authentication succeeds,
/// throws [AuthException] if it fails.
Future<User> authenticate(String email, String password) async {
  // Implementation
}
```

## Development Workflow

### Setting Up Local Environment

```bash
# Clone repository
git clone https://github.com/abduznik/Flutter-Android-App-CodeSpaces.git
cd Flutter-Android-App-CodeSpaces

# Get dependencies
make deps

# Verify setup
make doctor
```

### During Development

```bash
# Run app with hot reload
make run

# Watch tests during development
make test-watch

# Format code before committing
make format

# Analyze code for issues
make analyze
```

### Before Pushing

```bash
# Clean build
make clean

# Run all tests
make test

# Build APK to verify
make build-apk

# Check for uncommitted changes
git status

# Review changes
git diff

# Commit and push
git add .
git commit -m "feat: your feature"
git push origin feature/your-feature-name
```

## Documentation Updates

When adding new features, update relevant documentation:

- **README.md** - User-facing features
- **SETUP.md** - Build/setup changes
- **Code comments** - Complex logic
- **Dart docs** - Public APIs

## Reporting Issues

When reporting bugs, include:

1. **Description**: What happened?
2. **Steps to Reproduce**: How to reproduce the issue
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**: Flutter version, device, OS
6. **Logs**: Error messages or stack traces

### Example Issue

```
Title: Login button doesn't respond on slow networks

Description:
When the network connection is slow, clicking the login button 
multiple times causes unexpected behavior.

Steps to Reproduce:
1. Throttle network to slow connection (DevTools)
2. Open login page
3. Click login button rapidly
4. Observe multiple login attempts

Expected: Button should be disabled during request
Actual: Multiple login requests are sent

Environment:
- Flutter 3.24.0
- Android 14
- Pixel 6
```

## Licensing

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Questions?

Feel free to:
- Open an issue for questions
- Ask in discussions
- Contact the maintainers

Thank you for contributing! 🎉
