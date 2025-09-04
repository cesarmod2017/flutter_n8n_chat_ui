# Flutter N8N Chat UI

[![pub package](https://img.shields.io/pub/v/flutter_n8n_chat_ui.svg)](https://pub.dev/packages/flutter_n8n_chat_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-flutter-blue)](https://flutter.dev)

A comprehensive Flutter chat UI package designed for seamless **n8n webhook integrations**. This package provides a complete chat interface with real-time messaging, audio recording, image sharing, message caching, pagination, custom theming, and multilingual support across all platforms.

## 🚀 Features

- ✅ **n8n Webhook Integration** - Direct integration with n8n automation workflows
- 💬 **Real-time Messaging** - Text messages with typing indicators and response handling
- 🎵 **Audio Support** - Voice message recording and playback with waveform visualization
- 📷 **Image Sharing** - Image picker integration with base64 conversion for API compatibility
- 💾 **Message Caching** - Optional message history with pagination (10 messages at a time)
- ♾️ **Infinite Scroll** - Load more messages automatically when scrolling to top
- 🎨 **Custom Theming** - Extensive customization with 40+ styling options
- 🌐 **Multi-language** - Built-in localization (Portuguese, English) with custom language support
- 📱 **Cross-platform** - Android, iOS, Web, Windows, macOS, Linux
- 🔧 **Interactive Elements** - Support for buttons, links, and custom message types
- 🎯 **Material 3** - Full integration with Flutter's latest design system
- 🌈 **Real-time Theme Switching** - Dynamic color updates with global theme provider

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_n8n_chat_ui:
    git:
      url: https://github.com/cesarmod2017/flutter_n8n_chat_ui.git
```

Then run:

```bash
flutter pub get
```

## 🎯 Quick Start

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_n8n_chat_ui/flutter_n8n_chat_ui.dart';

class MyChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = ChatConfig(
      webhookUrl: 'https://your-n8n-instance.com/webhook/chat',
      chatName: 'My Assistant',
      title: 'Hello! I am your assistant',
      subtitle: 'How can I help you today?',
      enableAudio: true,
      enableImage: true,
    );

    return Scaffold(
      body: N8NChatWidget(
        config: config,
        onMessageSent: (message) {
          print('Message sent: ${message.content}');
        },
        onMessageReceived: (message) {
          print('Message received: ${message.content}');
        },
      ),
    );
  }
}
```

### Custom Header Example

```dart
N8NChatWidget(
  config: config,
  headerWidget: Row(
    children: [
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      CircleAvatar(
        backgroundImage: NetworkImage(config.profileImageUrl),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.chatName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              'Online',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'info', child: Text('Info')),
          PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
        ],
      ),
    ],
  ),
)
```

## 🛠 Technologies Used

- **Flutter SDK** 3.0+ - Cross-platform mobile development framework
- **Dart** 3.0+ - Programming language optimized for building mobile, desktop, server, and web applications
- **HTTP** - Network requests for webhook communication
- **Image Picker** - Camera and gallery image selection
- **Audio Recording** - Voice message recording and playback
- **Permission Handler** - Runtime permissions management
- **URL Launcher** - Handle links and external URLs
- **Path Provider** - File system path access
- **Intl** - Internationalization and localization support
- **UUID** - Unique identifier generation
- **Material 3** - Google's latest design system

## 📋 Configuration Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `webhookUrl` | `String` | **Required**. The n8n webhook URL endpoint for sending messages |

### Connection Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cacheUrl` | `String?` | `null` | Optional URL for message history caching API |

### User Information

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `userName` | `String` | `''` | Display name for the user |
| `userEmail` | `String` | `''` | User email identifier for message history |
| `chatName` | `String` | `'N8N Chat'` | Name of the chat assistant/bot |
| `profileImageUrl` | `String` | Generated avatar | URL for bot/assistant profile image |

### Message Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | `'Olá seja bem vindo'` | Welcome message title |
| `subtitle` | `String` | `'Eu sou o bot que irá atender você...'` | Welcome message subtitle |
| `hintText` | `String` | `'Digite uma mensagem...'` | Placeholder text for input field |
| `language` | `String` | `'pt-BR'` | Language code for localization |

### Visual Customization

#### Background Colors
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `backgroundColor` | `String?` | Theme surface | Main chat background color |
| `headerBackgroundColor` | `String?` | Theme primary | Header background color |
| `footerBackgroundColor` | `String?` | Theme surface | Input field background color |
| `backgroundChatUser` | `String` | `'#5B9BD5'` | User message bubble color |
| `backgroundChatAssistant` | `String` | `'#F0F0F0'` | Assistant message bubble color |

#### Text Colors
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `textColor` | `String?` | Theme onSurface | Main text color |
| `textColorAssistant` | `String?` | Theme onSurfaceVariant | Assistant message text color |
| `headerTextColor` | `String?` | Theme onPrimary | Header text color |

#### Button Colors
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sendButtonColor` | `String?` | Theme primary | Send button color |
| `audioButtonColor` | `String?` | Theme secondary | Audio recording button color |
| `imageButtonColor` | `String?` | Theme tertiary | Image picker button color |
| `buttonBackgroundColor` | `String?` | Theme primaryContainer | Interactive button background |
| `buttonTextColor` | `String?` | Theme onPrimaryContainer | Interactive button text color |
| `buttonBorderColor` | `String?` | Theme outline | Interactive button border color |

#### Theme Colors (Material 3)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `themePrimaryColor` | `String?` | `'#5B9BD5'` | Material 3 primary color |
| `themeSecondaryColor` | `String?` | `'#70AD47'` | Material 3 secondary color |
| `themeTertiaryColor` | `String?` | `'#FFC000'` | Material 3 tertiary color |

### Feature Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableAudio` | `bool` | `false` | Enable voice message recording |
| `enableImage` | `bool` | `false` | Enable image sharing |
| `waitForResponse` | `bool` | `true` | Prevent multiple messages until response |

### UI Customization

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `buttonBorderRadius` | `double` | `8.0` | Border radius for interactive buttons |
| `showHeader` | `bool` | `true` | Show/hide the header bar |

### Custom Data

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `customData` | `Map<String, dynamic>?` | `null` | Additional data sent with every message |

## 🎨 Advanced Examples

### Healthcare Chat Example

```dart
final healthcareConfig = ChatConfig(
  webhookUrl: 'https://n8n.example.com/webhook/healthcare',
  cacheUrl: 'https://api.example.com/cache',
  
  // User info
  chatName: 'HealthCare Assistant',
  userName: 'Patient',
  userEmail: 'patient@example.com',
  
  // Messages
  title: 'Hello! I am your Healthcare Assistant',
  subtitle: 'I can help you with medical questions and appointments',
  hintText: 'Ask me about your health...',
  language: 'en',
  
  // Healthcare theme
  backgroundColor: '#FAFAFA',
  headerBackgroundColor: '#4CAF50',
  headerTextColor: '#FFFFFF',
  backgroundChatUser: '#4CAF50',
  backgroundChatAssistant: '#E8F5E8',
  textColor: '#000000',
  textColorAssistant: '#2E7D32',
  sendButtonColor: '#4CAF50',
  
  // Features
  enableAudio: true,
  enableImage: true,
  audioButtonColor: '#FF5722',
  imageButtonColor: '#2196F3',
  
  // Avatar
  profileImageUrl: 'https://ui-avatars.com/api/?name=Health+Assistant&background=4CAF50&color=ffffff&size=128',
  
  // Custom metadata
  customData: {
    'department': 'general',
    'priority': 'normal',
    'patientType': 'returning',
  },
);
```

### Corporate Theme Example

```dart
final corporateConfig = ChatConfig(
  webhookUrl: 'https://company.n8n.com/webhook/support',
  
  // Corporate branding
  chatName: 'Corporate Support',
  title: 'Welcome to Corporate Support',
  subtitle: 'Our team is here to help you 24/7',
  
  // Corporate colors
  backgroundColor: '#F8F9FA',
  headerBackgroundColor: '#1E3A8A',
  headerTextColor: '#FFFFFF',
  backgroundChatUser: '#3B82F6',
  backgroundChatAssistant: '#EFF6FF',
  textColorAssistant: '#1E40AF',
  sendButtonColor: '#1E3A8A',
  
  // Professional styling
  buttonBorderRadius: 6.0,
  enableAudio: false, // Audio disabled for corporate
  enableImage: true,
  
  profileImageUrl: 'https://company.com/logo.png',
);
```

### E-commerce Chat Example

```dart
final ecommerceConfig = ChatConfig(
  webhookUrl: 'https://store.n8n.com/webhook/sales',
  
  chatName: 'Sales Assistant',
  title: '🛍️ Welcome to our Store!',
  subtitle: 'Find the perfect products and get instant support',
  hintText: 'Ask about products, orders, or shipping...',
  
  // E-commerce colors
  backgroundColor: '#FFFFFF',
  headerBackgroundColor: '#7C3AED',
  backgroundChatUser: '#8B5CF6',
  backgroundChatAssistant: '#F3E8FF',
  textColorAssistant: '#6B21A8',
  
  // Shopping features
  enableImage: true,
  enableAudio: false,
  
  customData: {
    'source': 'mobile_app',
    'currency': 'USD',
    'locale': 'en-US',
  },
);
```

## 🔧 Widget Options

### N8NChatWidget Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `config` | `ChatConfig` | **Required**. Configuration object with all chat settings |
| `messageBuilder` | `Widget Function(ChatMessage)?` | Custom message bubble builder |
| `onMessageSent` | `Function(ChatMessage)?` | Callback when user sends a message |
| `onMessageReceived` | `Function(ChatMessage)?` | Callback when receiving API response |
| `headerWidget` | `Widget?` | Custom header widget (overrides default header) |
| `footerWidget` | `Widget?` | Custom footer widget (overrides input field) |
| `showHeader` | `bool` | Show/hide the header bar (default: true) |

### Custom Message Builder Example

```dart
N8NChatWidget(
  config: config,
  messageBuilder: (message) {
    if (message.sender == MessageSender.user) {
      return CustomUserBubble(message: message);
    } else {
      return CustomAssistantBubble(message: message);
    }
  },
)
```

## 🌐 Localization

The package includes built-in localization for Portuguese (`pt-BR`) and English (`en`). You can add custom languages by extending the localization system:

### Supported Languages

- **Portuguese (pt-BR)** - Default
- **English (en)**
- **Spanish (es)** - Partial support
- **French (fr)** - Partial support

### Using Different Languages

```dart
final config = ChatConfig(
  webhookUrl: 'https://your-webhook.com',
  language: 'en', // English
  title: 'Hello! Welcome to our chat',
  subtitle: 'How can I help you today?',
  hintText: 'Type a message...',
);
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Full Support | All features including audio/image |
| iOS | ✅ Full Support | All features including audio/image |
| Web | ✅ Full Support | Audio recording requires HTTPS |
| Windows | ✅ Full Support | Desktop optimized layout |
| macOS | ✅ Full Support | Native macOS styling |
| Linux | ✅ Full Support | GTK integration |

## 🔄 Message Flow

### Sending Messages

1. User types/records/selects content
2. Message is added to local chat
3. `onMessageSent` callback is triggered
4. Message is sent to n8n webhook as JSON
5. Response is parsed and displayed
6. `onMessageReceived` callback is triggered

### Message Format (Sent to n8n)

```json
{
  "id": "1640123456789",
  "content": "Hello, I need help",
  "type": "text",
  "sender": "user",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "userName": "John Doe",
  "userEmail": "john@example.com",
  "language": "en",
  "chatName": "Support Chat",
  "customField1": "value1",
  "customField2": "value2"
}
```

### Expected Response Format

```json
[
  {
    "messages": [
      {
        "type": "text",
        "text": "Hello! How can I help you today?"
      }
    ],
    "buttons": [
      {
        "text": "Get Support",
        "value": "support"
      },
      {
        "text": "View Products", 
        "value": "products"
      }
    ],
    "links": [
      {
        "text": "Visit our website",
        "url": "https://example.com"
      }
    ]
  }
]
```

## 🎬 Real-time Theme Switching

The package includes a global theme provider for real-time color updates:

```dart
import 'package:flutter_n8n_chat_ui/flutter_n8n_chat_ui.dart';

// In your main app
class MyApp extends StatefulWidget {
  static final chatColorsProvider = ChatColorsProvider();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyApp.chatColorsProvider.createTheme(Brightness.light),
      darkTheme: MyApp.chatColorsProvider.createTheme(Brightness.dark),
      home: ChatScreen(),
    );
  }
}

// Update theme colors globally
MyApp.chatColorsProvider.updateThemeColors(
  primaryColor: 'FF5722',
  secondaryColor: '4CAF50',
  tertiaryColor: 'FFC107',
);
```

## 🔍 Message History & Pagination

Enable message caching and pagination:

```dart
final config = ChatConfig(
  webhookUrl: 'https://your-webhook.com',
  cacheUrl: 'https://your-api.com/cache', // Enable caching
  userEmail: 'user@example.com', // Required for cache key
);
```

**Pagination Features:**
- Loads last 10 messages initially
- Infinite scroll loads 10 more messages when scrolling to top
- Preserves scroll position during loading
- Shows loading indicator while fetching

**Cache API Expected Format:**
```json
{
  "messages": [
    {
      "type": "human",
      "data": {
        "content": "User message"
      }
    },
    {
      "type": "ai", 
      "data": {
        "content": "{\"response\":{\"messages\":[{\"type\":\"text\",\"text\":\"AI response\"}]}}"
      }
    }
  ]
}
```

## 🎵 Audio Features

Enable audio recording with customization:

```dart
final config = ChatConfig(
  webhookUrl: 'https://your-webhook.com',
  enableAudio: true,
  audioButtonColor: '#FF5722', // Custom audio button color
);
```

**Audio Features:**
- Real-time recording with waveform visualization
- Automatic audio compression
- Base64 encoding for API transmission
- Playback controls with progress indicator
- Multiple audio formats support (AAC, MP3, WAV)

**Required Permissions:**
- Android: `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE`
- iOS: `NSMicrophoneUsageDescription` in Info.plist
- Web: Microphone access permission

## 📷 Image Features

Enable image sharing:

```dart
final config = ChatConfig(
  webhookUrl: 'https://your-webhook.com',
  enableImage: true,
  imageButtonColor: '#2196F3', // Custom image button color
);
```

**Image Features:**
- Camera capture and gallery selection
- Automatic image compression and resizing
- Base64 encoding for API compatibility
- Preview before sending
- Multiple image formats support (JPEG, PNG, WebP)

**Required Permissions:**
- Android: `CAMERA`, `READ_EXTERNAL_STORAGE`
- iOS: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` in Info.plist

## 🔔 Event Callbacks

```dart
N8NChatWidget(
  config: config,
  onMessageSent: (ChatMessage message) {
    // Handle sent messages
    print('Sent: ${message.content}');
    analytics.trackMessageSent(message.type);
  },
  onMessageReceived: (ChatMessage message) {
    // Handle received messages  
    print('Received: ${message.content}');
    analytics.trackMessageReceived();
    
    // Show notification if app is backgrounded
    if (!isAppActive) {
      showNotification(message.content);
    }
  },
)
```

## 🚀 Performance Optimization

The package includes several performance optimizations:

- **Lazy Loading**: Messages are loaded in chunks
- **Image Optimization**: Automatic compression and resizing
- **Memory Management**: Efficient widget recycling
- **Network Optimization**: Request deduplication and caching
- **Scroll Performance**: Optimized ListView with item extent

## 🐛 Troubleshooting

### Common Issues

**1. Audio not working**
```dart
// Ensure permissions are granted
await Permission.microphone.request();
```

**2. Images not uploading**
```dart
// Check file size limits in your n8n workflow
final config = ChatConfig(
  enableImage: true,
  // Images are automatically compressed to 1MB max
);
```

**3. Messages not loading from cache**
```dart
// Ensure userEmail is set for cache key generation
final config = ChatConfig(
  cacheUrl: 'https://your-api.com',
  userEmail: 'user@example.com', // Required!
);
```

**4. Theme colors not applying**
```dart
// Use hex colors without # prefix
backgroundColor: 'FF5722', // ✅ Correct
backgroundColor: '#FF5722', // ❌ Will be parsed but # is removed
```

## 📚 API Documentation

### ChatMessage Class

```dart
class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final MessageSender sender;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final String? chatName;
  final String? language;
  final String? filePath;
  final String? filename;
  final List<ChatButton>? buttons;
  final List<ChatLink>? links;
  final ChatMeta? meta;
}
```

### MessageType Enum

```dart
enum MessageType {
  text,      // Regular text message
  audio,     // Voice message
  image,     // Image message
  buttons,   // Interactive buttons
  links,     // Link collection
}
```

### MessageSender Enum

```dart
enum MessageSender {
  user,      // Message from user
  assistant, // Message from AI/bot
}
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** with proper documentation
4. **Add tests** for new functionality
5. **Run tests**: `flutter test`
6. **Check formatting**: `dart format .`
7. **Run analysis**: `flutter analyze`
8. **Commit changes**: `git commit -m 'Add amazing feature'`
9. **Push to branch**: `git push origin feature/amazing-feature`
10. **Create Pull Request**

### Development Setup

```bash
git clone https://github.com/cesarmod2017/flutter_n8n_chat_ui.git
cd flutter_n8n_chat_ui
flutter pub get
cd example
flutter run
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- n8n team for the powerful automation platform
- Material Design team for the design system
- Contributors and community members

## 📞 Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/cesarmod2017/flutter_n8n_chat_ui/issues)
- **Documentation**: [Full API documentation](https://github.com/cesarmod2017/flutter_n8n_chat_ui/wiki)
- **Examples**: Check the `/example` folder for complete implementations

---

**Made with ❤️ for the Flutter and n8n communities**