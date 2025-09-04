# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added
- **Complete Chat UI Package**: Full-featured chat interface for n8n webhook integrations
- **Real-time Messaging**: Support for text messages with typing indicators
- **Audio Support**: Voice message recording and playback with customizable button colors
- **Image Support**: Image sharing capabilities with picker integration
- **Message Caching**: Optional message history caching with pagination support
- **Pagination System**: Load messages in chunks (10 at a time) with infinite scroll
- **Multi-language Support**: Built-in localization system with Portuguese and English
- **Custom Theming**: Extensive customization options for colors, fonts, and styling
- **Material 3 Support**: Full integration with Flutter's Material 3 design system
- **Global Theme Provider**: Real-time theme switching with ChatColorsProvider
- **Platform Support**: Cross-platform compatibility (Android, iOS, Web, Windows, macOS, Linux)
- **Custom Data Integration**: Support for sending additional metadata with messages
- **Button Interactions**: Support for interactive buttons in chat responses
- **Link Support**: Automatic link detection and custom link rendering
- **Avatar System**: Profile image support with fallback to generated avatars
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Accessibility**: Screen reader support and keyboard navigation

### Features
- **N8NChatWidget**: Main chat widget component
- **ChatConfig**: Comprehensive configuration system with 40+ customization options
- **ChatService**: HTTP service for webhook communication and message caching
- **MessageBubble**: Customizable message rendering with different types (text, audio, image, buttons, links)
- **ChatInputField**: Rich input field with audio recording, image picker, and send functionality
- **TypingIndicator**: Animated typing indicator for better user experience
- **AudioService**: Audio recording and playback management
- **ImageService**: Image processing and base64 conversion
- **LocalizationHelper**: Multi-language support system

### Configuration Options
- **Connection**: `webhookUrl` (required), `cacheUrl` (optional)
- **User Information**: `userName`, `userEmail`, `chatName`
- **Messages**: `title`, `subtitle`, `hintText`, `language`
- **Colors**: Complete color customization for all UI elements
- **Features**: Toggle audio/image support, response waiting behavior
- **Buttons**: Custom styling for interactive elements
- **Theme**: Material 3 theme integration with primary/secondary/tertiary colors

### Technical Details
- **Dependencies**: http, intl, uuid, record, audioplayers, image_picker, permission_handler, path_provider, url_launcher
- **Architecture**: Modular design with separate services and widgets
- **State Management**: Built-in state management with ChangeNotifier
- **Performance**: Optimized message loading with pagination and lazy rendering
- **Error Handling**: Comprehensive error handling for network and media operations

### Examples
- **Basic Chat**: Simple chat implementation with default settings
- **Custom Theme**: Advanced theming example with healthcare styling
- **Configuration Screen**: Interactive configuration interface for testing all parameters

## [0.0.1] - 2024-01-01

### Added
- Initial project setup
- Basic package structure
- Core dependencies configuration