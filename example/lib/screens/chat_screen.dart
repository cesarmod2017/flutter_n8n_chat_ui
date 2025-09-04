import 'package:flutter/material.dart';
import 'package:flutter_n8n_chat_ui/flutter_n8n_chat_ui.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatConfig config;

  const ChatScreen({
    super.key,
    required this.config,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  @override
  void initState() {
    super.initState();
    // Listen to theme changes to rebuild with new colors
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
    return Scaffold(
      body: N8NChatWidget(
        config: widget.config,
        onMessageSent: (message) {
          debugPrint('Message sent: ${message.content}');
        },
        onMessageReceived: (message) {
          debugPrint('Message received: ${message.content}');
        },
        headerWidget: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Voltar',
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: ClipOval(
                child: widget.config.profileImageUrl.isNotEmpty
                    ? Image.network(
                        widget.config.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.chat_bubble,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      )
                    : const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 24,
                      ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.config.chatName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                switch (value) {
                  case 'info':
                    _showInfoDialog(context);
                    break;
                  case 'config':
                    _showConfigDialog(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'info',
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Informações'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'config',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Configurações'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.config.chatName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.config.title.isNotEmpty) ...[
                const Text('Título:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.config.title),
                const SizedBox(height: 8),
              ],
              if (widget.config.subtitle.isNotEmpty) ...[
                const Text('Subtítulo:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.config.subtitle),
                const SizedBox(height: 8),
              ],
              const Text('Recursos:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Áudio: ${widget.config.enableAudio ? 'Habilitado' : 'Desabilitado'}'),
              Text('• Imagem: ${widget.config.enableImage ? 'Habilitado' : 'Desabilitado'}'),
              const SizedBox(height: 8),
              const Text('Webhook:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                widget.config.webhookUrl,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showConfigDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações Atuais'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildConfigSection('Configurações Básicas', [
                  _buildConfigItem('Webhook URL', widget.config.webhookUrl),
                  if (widget.config.cacheUrl != null) _buildConfigItem('Cache URL', widget.config.cacheUrl!),
                  _buildConfigItem('Idioma', widget.config.language),
                  _buildConfigItem('Nome do Chat', widget.config.chatName),
                ]),
                _buildConfigSection('Interface', [
                  _buildConfigItem('Título', widget.config.title),
                  _buildConfigItem('Subtítulo', widget.config.subtitle),
                  _buildConfigItem('Texto do Input', widget.config.hintText),
                ]),
                _buildConfigSection('Usuário', [
                  if (widget.config.userName.isNotEmpty) _buildConfigItem('Nome', widget.config.userName),
                  if (widget.config.userEmail.isNotEmpty) _buildConfigItem('Email', widget.config.userEmail),
                ]),
                _buildConfigSection('Cores', [
                  _buildColorItem('Fundo', widget.config.backgroundColor ?? 'Default'),
                  _buildColorItem('Header', widget.config.headerBackgroundColor ?? 'Default'),
                  _buildColorItem('Usuário', widget.config.backgroundChatUser),
                  _buildColorItem('Assistente', widget.config.backgroundChatAssistant),
                ]),
                _buildConfigSection('Recursos', [
                  _buildConfigItem('Áudio', widget.config.enableAudio ? 'Habilitado' : 'Desabilitado'),
                  _buildConfigItem('Imagem', widget.config.enableImage ? 'Habilitado' : 'Desabilitado'),
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(String label, String colorValue) {
    Color color;
    try {
      color = Color(int.parse(colorValue.replaceFirst('#', 'FF'), radix: 16));
    } catch (e) {
      color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            colorValue,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}