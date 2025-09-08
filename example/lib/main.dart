import 'package:flutter/material.dart';
import 'package:flutter_n8n_chat_ui/flutter_n8n_chat_ui.dart';
import 'screens/config_screen.dart';
import 'theme_provider.dart';
import 'chat_colors_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Make providers static and accessible
  static final themeProvider = ThemeProvider();
  static final chatColorsProvider = ChatColorsProvider();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    MyApp.themeProvider.addListener(_onThemeChanged);
    MyApp.chatColorsProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    MyApp.themeProvider.removeListener(_onThemeChanged);
    MyApp.chatColorsProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter N8N Chat UI Example',
      theme: MyApp.chatColorsProvider.createTheme(Brightness.light),
      darkTheme: MyApp.chatColorsProvider.createTheme(Brightness.dark),
      themeMode: MyApp.themeProvider.themeMode,
      home: const ExampleListScreen(),
    );
  }
}

class ExampleListScreen extends StatelessWidget {
  const ExampleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('N8N Chat UI Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            context,
            'Configurador de Chat',
            'Configure todos os parâmetros do chat e teste diferentes configurações',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfigScreen()),
            ),
            icon: Icons.settings,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Basic Chat',
            'Simple chat example with default configuration',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BasicChatExample()),
            ),
            icon: Icons.chat_bubble_outline,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Custom Theme Chat',
            'Chat with custom colors and styling',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomThemeChatExample(),
              ),
            ),
            icon: Icons.palette,
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Healthcare Chat',
            'Healthcare-themed chat example',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HealthcareChatExample(),
              ),
            ),
            icon: Icons.local_hospital,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'No Header Chat',
            'Full screen chat without header/app bar',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoHeaderChatExample(),
              ),
            ),
            icon: Icons.fullscreen,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap, {
    IconData? icon,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (color ?? Colors.blue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BasicChatExample extends StatelessWidget {
  const BasicChatExample({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ChatConfig(
      webhookUrl: 'https://n8n.modspace.com.br/webhook/healthsupply_chat',
      chatName: 'Basic Chat Bot',
      title: 'Hello! I am your assistant',
      subtitle: 'How can I help you today?',
      enableAudio: true,
      enableImage: true,
    );

    return Scaffold(
      body: N8NChatWidget(
        config: config,
        headerWidget: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Basic Chat Bot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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

class CustomThemeChatExample extends StatelessWidget {
  const CustomThemeChatExample({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ChatConfig(
      webhookUrl: 'https://n8n.modspace.com.br/webhook/healthsupply_chat',
      chatName: 'Custom Bot',
      title: 'Welcome to Custom Chat!',
      subtitle: 'This chat has custom styling',
      backgroundColor: '#F5F5F5',
      headerBackgroundColor: '#6200EE',
      headerTextColor: '#FFFFFF',
      backgroundChatUser: '#6200EE',
      backgroundChatAssistant: '#E3F2FD',
      textColor: '#000000',
      textColorAssistant: '#1976D2',
      sendButtonColor: '#6200EE',
      hintText: 'Type your message here...',
      profileImageUrl:
          'https://ui-avatars.com/api/?name=Custom+Bot&background=6200EE&color=ffffff&size=128',
    );

    return Scaffold(
      body: N8NChatWidget(
        config: config,
        headerWidget: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Custom Bot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        onMessageSent: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sent: ${message.content}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        onMessageReceived: (message) {
          print('Custom themed message received: ${message.content}');
        },
      ),
    );
  }
}

class HealthcareChatExample extends StatelessWidget {
  const HealthcareChatExample({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ChatConfig(
      webhookUrl: 'https://n8n.modspace.com.br/webhook/healthsupply_chat',
      chatName: 'HealthCare Assistant',
      userName: 'Patient',
      userEmail: 'patient@example.com',
      title: 'Hello! I am your Healthcare Assistant',
      subtitle: 'I can help you with medical questions and appointments',
      backgroundColor: '#FAFAFA',
      headerBackgroundColor: '#4CAF50',
      headerTextColor: '#FFFFFF',
      backgroundChatUser: '#4CAF50',
      backgroundChatAssistant: '#E8F5E8',
      textColor: '#000000',
      textColorAssistant: '#2E7D32',
      sendButtonColor: '#4CAF50',
      hintText: 'Ask me about your health...',
      profileImageUrl:
          'https://ui-avatars.com/api/?name=Health+Assistant&background=4CAF50&color=ffffff&size=128',
      enableAudio: true,
      enableImage: true,
      audioButtonColor: '#FF5722',
      imageButtonColor: '#2196F3',
      customData: {'department': 'general', 'priority': 'normal'},
    );

    return Scaffold(
      body: N8NChatWidget(
        config: config,
        headerWidget: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.local_hospital,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'HealthCare Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Always here to help',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                _showInfoDialog(context);
              },
            ),
          ],
        ),
        onMessageSent: (message) {
          print('Healthcare message sent: ${message.content}');
        },
        onMessageReceived: (message) {
          print('Healthcare message received: ${message.content}');
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Healthcare Assistant'),
        content: const Text(
          'This is a healthcare-themed chat example.\n\n'
          'Features:\n'
          '• Custom healthcare styling\n'
          '• Audio and image support enabled\n'
          '• Custom header with medical icon\n'
          '• Patient information integration',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class NoHeaderChatExample extends StatelessWidget {
  const NoHeaderChatExample({super.key});

  @override
  Widget build(BuildContext context) {
    final config = ChatConfig(
      webhookUrl: 'https://n8n.modspace.com.br/webhook/healthsupply_chat',
      chatName: 'Full Screen Bot',
      title: 'Welcome to Full Screen Chat!',
      subtitle: 'This chat uses the full screen without header',
      backgroundColor: '#FFFFFF',
      backgroundChatUser: '#007AFF',
      backgroundChatAssistant: '#F1F1F1',
      textColor: '#000000',
      textColorAssistant: '#333333',
      sendButtonColor: '#007AFF',
      hintText: 'Message...',
      showAppBar: false, // This is the key difference!
      profileImageUrl:
          'https://ui-avatars.com/api/?name=FS+Bot&background=007AFF&color=ffffff&size=128',
      enableAudio: true,
      enableImage: true,
    );

    return Scaffold(
      body: Stack(
        children: [
          N8NChatWidget(
            config: config,
            onMessageSent: (message) {
              print('No header message sent: ${message.content}');
            },
            onMessageReceived: (message) {
              print('No header message received: ${message.content}');
            },
          ),
          // Floating back button since there's no app bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Optional floating info button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This chat runs in full screen mode without the app bar! '
                        'Perfect for immersive chat experiences.',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
