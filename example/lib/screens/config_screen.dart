import 'package:flutter/material.dart';
import 'package:flutter_n8n_chat_ui/flutter_n8n_chat_ui.dart';

import '../main.dart';
import 'chat_screen.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Current locale for real-time language switching
  late ValueNotifier<Locale> _currentLocale;
  late AppLocalizations _localizations;

  // Theme mode
  String _selectedThemeMode = 'system'; // system, light, dark

  // Controllers para todos os campos
  final _webhookUrlController = TextEditingController(text: "{URL WEBHOOK}");
  final _cacheUrlController = TextEditingController(text: "{URL CACHE}");
  final _languageController = TextEditingController(text: 'pt-BR');
  final _titleController = TextEditingController(text: 'Olá seja bem vindo');
  final _subtitleController = TextEditingController(
    text: 'Eu sou o bot que irá atender você, em que posso ajudar?',
  );
  final _userNameController = TextEditingController(text: 'Patient');
  final _userEmailController = TextEditingController(
    text: 'patient@example.com',
  );
  final _chatNameController = TextEditingController(text: 'N8N Chat');
  final _hintTextController = TextEditingController(
    text: 'Digite uma mensagem...',
  );
  final _profileImageUrlController = TextEditingController(
    text:
        'https://ui-avatars.com/api/?name=N8N+Bot&background=4CAF50&color=ffffff&size=128',
  );

  // Controllers para cores
  final _backgroundColorController = TextEditingController();
  final _textColorController = TextEditingController();
  final _textColorAssistantController = TextEditingController(text: '000000');
  final _backgroundChatUserController = TextEditingController(text: '25D366');
  final _backgroundChatAssistantController = TextEditingController(
    text: 'F0F0F0',
  );
  final _footerBackgroundColorController = TextEditingController();
  final _audioButtonColorController = TextEditingController();
  final _imageButtonColorController = TextEditingController();
  final _sendButtonColorController = TextEditingController();
  final _headerBackgroundColorController = TextEditingController();
  final _headerTextColorController = TextEditingController();

  // Theme colors controllers
  final _themePrimaryColorController = TextEditingController(
    text: '5B9BD5',
  ); // Azul camurça
  final _themeSecondaryColorController = TextEditingController(
    text: '70AD47',
  ); // Verde complementar
  final _themeTertiaryColorController = TextEditingController(
    text: 'FFC000',
  ); // Dourado

  // Button colors controllers
  final _buttonBorderColorController = TextEditingController();
  final _buttonTextColorController = TextEditingController();
  final _buttonBackgroundColorController = TextEditingController();

  // Configurações booleanas
  bool _enableAudio = false;
  bool _enableImage = false;
  bool _waitForResponse = true;
  bool _showAppBar = true;

  // Custom data controller
  final _customDataController = TextEditingController();

  // Button border radius value
  double _buttonBorderRadius = 8.0;

  @override
  void initState() {
    super.initState();
    // Initialize with Portuguese Brazil as default
    _currentLocale = ValueNotifier(const Locale('pt', 'BR'));
    _localizations = AppLocalizations(_currentLocale.value);

    // Initialize theme mode from provider
    _selectedThemeMode = MyApp.themeProvider.currentThemeMode;

    // Update localizations when locale changes
    _currentLocale.addListener(() {
      setState(() {
        _localizations = AppLocalizations(_currentLocale.value);
      });
    });
  }

  @override
  void dispose() {
    _currentLocale.dispose();
    _webhookUrlController.dispose();
    _cacheUrlController.dispose();
    _languageController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _chatNameController.dispose();
    _hintTextController.dispose();
    _profileImageUrlController.dispose();
    _backgroundColorController.dispose();
    _textColorController.dispose();
    _textColorAssistantController.dispose();
    _backgroundChatUserController.dispose();
    _backgroundChatAssistantController.dispose();
    _footerBackgroundColorController.dispose();
    _audioButtonColorController.dispose();
    _imageButtonColorController.dispose();
    _sendButtonColorController.dispose();
    _headerBackgroundColorController.dispose();
    _headerTextColorController.dispose();
    _themePrimaryColorController.dispose();
    _themeSecondaryColorController.dispose();
    _themeTertiaryColorController.dispose();
    _buttonBorderColorController.dispose();
    _buttonTextColorController.dispose();
    _buttonBackgroundColorController.dispose();
    _customDataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_localizations.chatConfiguration),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetToDefaults,
            tooltip: _localizations.restoreDefaults,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(_localizations.basicSettings, [
              _buildTextFormField(
                '${_localizations.webhookUrl}*',
                _webhookUrlController,
                Icons.link,
                required: true,
                keyboardType: TextInputType.url,
              ),
              _buildTextFormField(
                _localizations.cacheUrl,
                _cacheUrlController,
                Icons.cached,
                keyboardType: TextInputType.url,
              ),
              _buildLanguageDropdown(),
              _buildThemeModeDropdown(),
              _buildTextFormField(
                _localizations.chatName,
                _chatNameController,
                Icons.chat,
              ),
            ]),
            _buildSection(_localizations.interfaceTexts, [
              _buildTextFormField(
                _localizations.title,
                _titleController,
                Icons.title,
              ),
              _buildTextFormField(
                _localizations.subtitle,
                _subtitleController,
                Icons.text_format,
              ),
              _buildTextFormField(
                _localizations.inputText,
                _hintTextController,
                Icons.text_fields,
              ),
            ]),
            _buildSection(_localizations.userInfo, [
              _buildTextFormField(
                _localizations.userName,
                _userNameController,
                Icons.person,
              ),
              _buildTextFormField(
                _localizations.userEmail,
                _userEmailController,
                Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
            ]),
            _buildSection(_localizations.interfaceColors, [
              _buildColorField(
                _localizations.backgroundColor,
                _backgroundColorController,
              ),
              _buildColorField(_localizations.textColor, _textColorController),
              _buildColorField(
                _localizations.assistantTextColor,
                _textColorAssistantController,
              ),
              _buildColorField(
                _localizations.userBackgroundColor,
                _backgroundChatUserController,
              ),
              _buildColorField(
                _localizations.assistantBackgroundColor,
                _backgroundChatAssistantController,
              ),
              _buildColorField(
                _localizations.footerBackgroundColor,
                _footerBackgroundColorController,
              ),
              _buildColorField(
                _localizations.headerBackgroundColor,
                _headerBackgroundColorController,
              ),
              _buildColorField(
                _localizations.headerTextColor,
                _headerTextColorController,
              ),
            ]),
            _buildSection(_localizations.buttonColors, [
              _buildColorField(
                _localizations.audioButtonColor,
                _audioButtonColorController,
              ),
              _buildColorField(
                _localizations.imageButtonColor,
                _imageButtonColorController,
              ),
              _buildColorField(
                _localizations.sendButtonColor,
                _sendButtonColorController,
              ),
            ]),
            _buildSection('Theme Colors', [
              _buildColorField('Primary Color', _themePrimaryColorController),
              _buildColorField(
                'Secondary Color',
                _themeSecondaryColorController,
              ),
              _buildColorField('Tertiary Color', _themeTertiaryColorController),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _applyThemeColors,
                  icon: const Icon(Icons.palette),
                  label: const Text('Aplicar Cores do Tema'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ]),
            _buildSection('UI Customization', [
              ListTile(
                title: Text('Button Border Radius'),
                subtitle: Text(
                  'Button corner radius (${_buttonBorderRadius.toStringAsFixed(1)}px)',
                ),
                leading: const Icon(Icons.border_style),
              ),
              Slider(
                value: _buttonBorderRadius,
                min: 0.0,
                max: 20.0,
                divisions: 20,
                onChanged: (value) =>
                    setState(() => _buttonBorderRadius = value),
              ),
              _buildColorField(
                'Button Border Color',
                _buttonBorderColorController,
              ),
              _buildColorField('Button Text Color', _buttonTextColorController),
              _buildColorField(
                'Button Background',
                _buttonBackgroundColorController,
              ),
            ]),
            _buildSection(_localizations.features, [
              SwitchListTile(
                title: Text(_localizations.enableAudio),
                subtitle: Text(_localizations.audioDescription),
                value: _enableAudio,
                onChanged: (value) => setState(() => _enableAudio = value),
                secondary: const Icon(Icons.mic),
              ),
              SwitchListTile(
                title: Text(_localizations.enableImage),
                subtitle: Text(_localizations.imageDescription),
                value: _enableImage,
                onChanged: (value) => setState(() => _enableImage = value),
                secondary: const Icon(Icons.image),
              ),
              SwitchListTile(
                title: Text(_localizations.waitForResponse),
                subtitle: Text(_localizations.waitDescription),
                value: _waitForResponse,
                onChanged: (value) => setState(() => _waitForResponse = value),
                secondary: const Icon(Icons.hourglass_empty),
              ),
              SwitchListTile(
                title: const Text('Show App Bar'),
                subtitle: const Text(
                  'Display the chat header with title and avatar',
                ),
                value: _showAppBar,
                onChanged: (value) => setState(() => _showAppBar = value),
                secondary: const Icon(Icons.title),
              ),
            ]),
            _buildSection(_localizations.customization, [
              _buildTextFormField(
                _localizations.profileImageUrl,
                _profileImageUrlController,
                Icons.account_circle,
                keyboardType: TextInputType.url,
              ),
              _buildTextFormField(
                _localizations.customDataJson,
                _customDataController,
                Icons.code,
                maxLines: 3,
                hintText: '{"key": "value", "department": "sales"}',
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previewConfig,
                  icon: const Icon(Icons.visibility),
                  label: Text(_localizations.previewConfiguration),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _startChat,
                  icon: const Icon(Icons.chat),
                  label: Text(_localizations.startChat),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildTextFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return _localizations.requiredField;
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final languages = <String, String>{
      'pt-BR': 'Português (Brasil)',
      'pt-PT': 'Português (Portugal)',
      'en-US': 'English (Estados Unidos)',
      'es-ES': 'Español (España)',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: _languageController.text.isNotEmpty
            ? _languageController.text
            : 'pt-BR',
        decoration: InputDecoration(
          labelText: _localizations.language,
          prefixIcon: const Icon(Icons.language),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        ),
        items: languages.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _languageController.text = value;
              // Update locale for real-time language switching
              _updateLocale(value);
            });
          }
        },
      ),
    );
  }

  void _updateLocale(String languageCode) {
    switch (languageCode) {
      case 'pt-BR':
        _currentLocale.value = const Locale('pt', 'BR');
        break;
      case 'pt-PT':
        _currentLocale.value = const Locale('pt', 'PT');
        break;
      case 'en-US':
        _currentLocale.value = const Locale('en', 'US');
        break;
      case 'es-ES':
        _currentLocale.value = const Locale('es', 'ES');
        break;
      default:
        _currentLocale.value = const Locale('pt', 'BR');
    }
  }

  Widget _buildThemeModeDropdown() {
    final themeMap = <String, String>{
      'system': _localizations.system,
      'light': _localizations.light,
      'dark': _localizations.dark,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedThemeMode,
        decoration: InputDecoration(
          labelText: _localizations.themeMode,
          prefixIcon: const Icon(Icons.palette),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        ),
        items: themeMap.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Icon(_getThemeIcon(entry.key), size: 20),
                const SizedBox(width: 8),
                Text(entry.value),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedThemeMode = value;
            });
            // Apply theme change immediately
            MyApp.themeProvider.setThemeMode(value);
          }
        },
      ),
    );
  }

  IconData _getThemeIcon(String themeMode) {
    switch (themeMode) {
      case 'light':
        return Icons.light_mode;
      case 'dark':
        return Icons.dark_mode;
      case 'system':
      default:
        return Icons.brightness_auto;
    }
  }

  Widget _buildColorField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: '#',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(int.parse('FF${controller.text}', radix: 16)),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        ),
        onChanged: (value) {
          if (value.length == 6) {
            setState(() {}); // Refresh color preview
          }
        },
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            try {
              int.parse(value, radix: 16);
              if (value.length != 6) {
                return _localizations.invalidFormat;
              }
            } catch (e) {
              return _localizations.invalidColor;
            }
          }
          return null;
        },
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _webhookUrlController.text =
          'https://n8n.modspace.com.br/webhook/healthsupply_chat';
      _cacheUrlController.clear();
      _languageController.text = 'pt-BR';
      _titleController.text = 'Olá seja bem vindo';
      _subtitleController.text =
          'Eu sou o bot que irá atender você, em que posso ajudar?';
      _userNameController.clear();
      _userEmailController.clear();
      _chatNameController.text = 'N8N Chat';
      _hintTextController.text = 'Digite uma mensagem...';
      _profileImageUrlController.text =
          'https://ui-avatars.com/api/?name=Chat+Bot&background=4CAF50&color=ffffff&size=128';

      _backgroundColorController.text = 'FFFFFF';
      _textColorController.text = '000000';
      _textColorAssistantController.text = '000000';
      _backgroundChatUserController.text = '25D366';
      _backgroundChatAssistantController.text = 'F0F0F0';
      _footerBackgroundColorController.text = 'FFFFFF';
      _audioButtonColorController.text = 'FF0000';
      _imageButtonColorController.text = '2196F3';
      _sendButtonColorController.text = '25D366';
      _headerBackgroundColorController.text = '075E54';
      _headerTextColorController.text = 'FFFFFF';
      _themePrimaryColorController.text = '5B9BD5';
      _themeSecondaryColorController.text = '70AD47';
      _themeTertiaryColorController.text = 'FFC000';
      _buttonBorderColorController.clear();
      _buttonTextColorController.clear();
      _buttonBackgroundColorController.clear();

      _enableAudio = false;
      _enableImage = false;
      _showAppBar = true;
      _buttonBorderRadius = 8.0;
      _customDataController.clear();
    });
  }

  void _applyThemeColors() {
    // Update the global theme colors provider
    MyApp.chatColorsProvider.updateThemeColors(
      primaryColor: _themePrimaryColorController.text.isEmpty
          ? null
          : _themePrimaryColorController.text,
      secondaryColor: _themeSecondaryColorController.text.isEmpty
          ? null
          : _themeSecondaryColorController.text,
      tertiaryColor: _themeTertiaryColorController.text.isEmpty
          ? null
          : _themeTertiaryColorController.text,
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Cores do tema aplicadas com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startChat() {
    if (_formKey.currentState!.validate()) {
      final config = _buildChatConfig();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(config: config)),
      );
    }
  }

  void _previewConfig() {
    final config = _buildChatConfig();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_localizations.chatConfiguration),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildConfigItem(_localizations.webhookUrl, config.webhookUrl),
              if (config.cacheUrl != null)
                _buildConfigItem(_localizations.cacheUrl, config.cacheUrl!),
              _buildConfigItem(_localizations.language, config.language),
              _buildConfigItem(_localizations.title, config.title),
              _buildConfigItem(_localizations.subtitle, config.subtitle),
              _buildConfigItem(_localizations.chatName, config.chatName),
              if (config.userName.isNotEmpty)
                _buildConfigItem(_localizations.userName, config.userName),
              if (config.userEmail.isNotEmpty)
                _buildConfigItem(_localizations.userEmail, config.userEmail),
              _buildConfigItem(
                _localizations.enableAudio,
                config.enableAudio ? _localizations.yes : _localizations.no,
              ),
              _buildConfigItem(
                _localizations.enableImage,
                config.enableImage ? _localizations.yes : _localizations.no,
              ),
              _buildConfigItem(
                _localizations.waitForResponse,
                config.waitForResponse ? _localizations.yes : _localizations.no,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_localizations.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startChat();
            },
            child: Text(_localizations.startChat),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  ChatConfig _buildChatConfig() {
    Map<String, dynamic>? customData;
    if (_customDataController.text.isNotEmpty) {
      try {
        customData = <String, dynamic>{'custom': _customDataController.text};
      } catch (e) {
        customData = null;
      }
    }

    return ChatConfig(
      webhookUrl: _webhookUrlController.text,
      cacheUrl: _cacheUrlController.text.isNotEmpty
          ? _cacheUrlController.text
          : null,
      language: _languageController.text,
      title: _titleController.text,
      subtitle: _subtitleController.text,
      backgroundColor: '#${_backgroundColorController.text}',
      textColor: '#${_textColorController.text}',
      textColorAssistant: '#${_textColorAssistantController.text}',
      userName: _userNameController.text,
      userEmail: _userEmailController.text,
      chatName: _chatNameController.text,
      backgroundChatUser: '#${_backgroundChatUserController.text}',
      backgroundChatAssistant: '#${_backgroundChatAssistantController.text}',
      hintText: _hintTextController.text,
      footerBackgroundColor: '#${_footerBackgroundColorController.text}',
      audioButtonColor: '#${_audioButtonColorController.text}',
      imageButtonColor: '#${_imageButtonColorController.text}',
      sendButtonColor: '#${_sendButtonColorController.text}',
      headerBackgroundColor: '#${_headerBackgroundColorController.text}',
      headerTextColor: '#${_headerTextColorController.text}',
      enableAudio: _enableAudio,
      enableImage: _enableImage,
      waitForResponse: _waitForResponse,
      profileImageUrl: _profileImageUrlController.text,
      buttonBorderRadius: _buttonBorderRadius,
      themePrimaryColor: '#${_themePrimaryColorController.text}',
      themeSecondaryColor: '#${_themeSecondaryColorController.text}',
      themeTertiaryColor: '#${_themeTertiaryColorController.text}',
      buttonBorderColor: _buttonBorderColorController.text.isNotEmpty
          ? '#${_buttonBorderColorController.text}'
          : null,
      buttonTextColor: _buttonTextColorController.text.isNotEmpty
          ? '#${_buttonTextColorController.text}'
          : null,
      buttonBackgroundColor: _buttonBackgroundColorController.text.isNotEmpty
          ? '#${_buttonBackgroundColorController.text}'
          : null,
      showAppBar: _showAppBar,
      customData: customData,
    );
  }
}
