# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package called `flutter_n8n_chat_ui` - a comprehensive chat UI widget designed for seamless n8n webhook integrations. The package provides a complete chat interface with real-time messaging, audio recording, image sharing, message caching, pagination, custom theming, and multilingual support across all platforms (Android, iOS, Web, Windows, macOS, Linux).

## Architecture

The codebase follows a clean architecture pattern with clear separation of concerns:

- **lib/src/models/** - Data models (ChatConfig, Message, ChatButton, ChatLink, ChatMeta)
- **lib/src/services/** - Business logic (ChatService for API calls, AudioService for recordings, ImageService for image handling)
- **lib/src/widgets/** - UI components (N8NChatWidget main widget, MessageBubble, ChatInputField, AudioRecorderWidget, etc.)
- **lib/src/localization/** - Internationalization support for multiple languages
- **example/** - Full example application demonstrating all features and theming options

The main widget `N8NChatWidget` accepts a `ChatConfig` object containing webhook URLs, colors, features toggles, and custom data. Messages are sent to n8n webhooks as JSON and responses are parsed to display text, buttons, links, and other interactive elements.

## Key Development Commands

```bash
# Install dependencies
flutter pub get

# Run the example app (from example/ directory)
cd example && flutter run

# Run tests
flutter test

# Analyze code for issues
flutter analyze

# Format code
dart format .

# Build for specific platforms (from example/ directory)
cd example
flutter build apk          # Android APK
flutter build ios          # iOS (requires macOS)
flutter build web          # Web
flutter build windows      # Windows
flutter build macos        # macOS
flutter build linux        # Linux
```

## Testing

Currently, the test suite is minimal (test/flutter_n8n_chat_ui_test.dart). When adding new features:
- Add unit tests for services in `test/services/`
- Add widget tests for new UI components in `test/widgets/`
- Test with the example app across different platforms

## Package Publishing

To publish updates to pub.dev:
```bash
# Ensure version is updated in pubspec.yaml
# Run checks before publishing
flutter pub publish --dry-run

# Publish to pub.dev
flutter pub publish
```

## Important Implementation Notes

1. **Message Format**: The package expects n8n webhook responses in a specific JSON format with messages array containing type, text, buttons, and links. See README.md for the complete format specification.

2. **Permissions**: Audio and image features require platform-specific permissions:
   - Android: Update `android/app/src/main/AndroidManifest.xml`
   - iOS: Update `ios/Runner/Info.plist`
   - Web: HTTPS required for microphone access

3. **State Management**: The package uses StatefulWidgets with local state management. The example app demonstrates using ChangeNotifier providers for theme management.

4. **Theming**: Supports Material 3 with dynamic color generation. Colors can be provided as hex strings (with or without #). The ChatColorsProvider creates Material 3 color schemes from primary, secondary, and tertiary colors.

5. **Localization**: Built-in support for pt-BR and en. Additional languages can be added by extending the localization files in lib/src/localization/.

## Code Style Guidelines

- Follow Flutter/Dart best practices and conventions
- Use meaningful variable and function names
- Keep widgets focused and compose smaller widgets
- Handle errors gracefully with try-catch blocks
- Dispose of controllers and streams properly
- Follow existing patterns in the codebase for consistency