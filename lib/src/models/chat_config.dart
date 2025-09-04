class ChatConfig {
  final String webhookUrl;
  final String? cacheUrl;
  final String language;
  final String title;
  final String subtitle;
  final String? backgroundColor; // Made optional
  final String? textColor; // Made optional
  final String? textColorAssistant; // Made optional
  final String userName;
  final String userEmail;
  final String chatName;
  final String backgroundChatUser; // Keep required for user bubble
  final String backgroundChatAssistant; // Keep required for assistant bubble
  final String hintText;
  final String? footerBackgroundColor; // Made optional
  final String? audioButtonColor; // Made optional
  final String? imageButtonColor; // Made optional
  final String? sendButtonColor; // Made optional
  final String? headerBackgroundColor; // Made optional
  final String? headerTextColor; // Made optional
  final bool enableAudio;
  final bool enableImage;
  final bool waitForResponse;
  final String profileImageUrl;
  final Map<String, dynamic>? customData;
  
  // Theme colors for Material 3
  final String? themePrimaryColor; // New field
  final String? themeSecondaryColor; // New field
  final String? themeTertiaryColor; // New field
  
  // UI customization
  final double buttonBorderRadius; // New field for button border radius
  
  // Button colors
  final String? buttonBorderColor; // Border color for buttons
  final String? buttonTextColor; // Text color for buttons  
  final String? buttonBackgroundColor; // Background color for buttons

  ChatConfig({
    required this.webhookUrl,
    this.cacheUrl,
    this.language = 'pt-BR',
    this.title = 'Olá seja bem vindo',
    this.subtitle = 'Eu sou o bot que irá atender você, em que posso ajudar?',
    this.backgroundColor,
    this.textColor,
    this.textColorAssistant,
    this.userName = '',
    this.userEmail = '',
    this.chatName = 'N8N Chat',
    this.backgroundChatUser = '#5B9BD5', // Azul camurça default
    this.backgroundChatAssistant = '#F0F0F0',
    this.hintText = 'Digite uma mensagem...',
    this.footerBackgroundColor,
    this.audioButtonColor,
    this.imageButtonColor,
    this.sendButtonColor,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.enableAudio = false,
    this.enableImage = false,
    this.waitForResponse = true,
    this.profileImageUrl = 'https://ui-avatars.com/api/?name=Chat+Bot&background=4CAF50&color=ffffff&size=128',
    this.customData,
    this.themePrimaryColor = '#5B9BD5', // Azul camurça
    this.themeSecondaryColor = '#70AD47', // Verde complementar
    this.themeTertiaryColor = '#FFC000', // Dourado para destaques
    this.buttonBorderRadius = 8.0,
    this.buttonBorderColor,
    this.buttonTextColor,
    this.buttonBackgroundColor,
  });

  factory ChatConfig.fromQueryParams(Map<String, String> params, {required String webhookUrl}) {
    return ChatConfig(
      webhookUrl: webhookUrl,
      cacheUrl: params['urlMessagesCache'],
      language: params['idioma'] ?? 'pt-BR',
      title: params['title'] ?? 'Olá seja bem vindo',
      subtitle:
          params['subtitle'] ??
          'Eu sou o bot que irá atender você, em que posso ajudar?',
      backgroundColor: params['backgroundColor'],
      textColor: params['textColor'],
      textColorAssistant: params['textColorAssistant'],
      userName: params['userName'] ?? '',
      userEmail: params['userEmail'] ?? '',
      chatName: params['chatName'] ?? 'N8N Chat',
      backgroundChatUser: params['backgroundChatUser'] ?? '#5B9BD5',
      backgroundChatAssistant: params['backgroundChatAssistant'] ?? '#F0F0F0',
      hintText: params['hintText'] ?? 'Digite uma mensagem...',
      footerBackgroundColor: params['footerBackgroundColor'],
      audioButtonColor: params['audioButtonColor'],
      imageButtonColor: params['imageButtonColor'],
      sendButtonColor: params['sendButtonColor'],
      headerBackgroundColor: params['headerBackgroundColor'],
      headerTextColor: params['headerTextColor'],
      enableAudio: params['enableAudio']?.toLowerCase() == 'true',
      enableImage: params['enableImage']?.toLowerCase() == 'true',
      waitForResponse: params['waitForResponse']?.toLowerCase() != 'false',
      profileImageUrl:
          params['profileImageUrl'] ?? 'https://ui-avatars.com/api/?name=Chat+Bot&background=4CAF50&color=ffffff&size=128',
      themePrimaryColor: params['themePrimaryColor'],
      themeSecondaryColor: params['themeSecondaryColor'],
      themeTertiaryColor: params['themeTertiaryColor'],
      buttonBorderRadius: double.tryParse(params['buttonBorderRadius'] ?? '8.0') ?? 8.0,
      buttonBorderColor: params['buttonBorderColor'],
      buttonTextColor: params['buttonTextColor'],
      buttonBackgroundColor: params['buttonBackgroundColor'],
    );
  }

  String toQueryString() {
    final params = <String, String>{};

    if (cacheUrl != null && cacheUrl!.isNotEmpty) {
      params['urlMessagesCache'] = cacheUrl!;
    }
    if (language != 'pt-BR') {
      params['idioma'] = language;
    }
    if (title != 'Olá seja bem vindo') {
      params['title'] = title;
    }
    if (subtitle != 'Eu sou o bot que irá atender você, em que posso ajudar?') {
      params['subtitle'] = subtitle;
    }
    if (backgroundColor != null && backgroundColor!.isNotEmpty) {
      params['backgroundColor'] = backgroundColor!;
    }
    if (textColor != null && textColor!.isNotEmpty) {
      params['textColor'] = textColor!;
    }
    if (textColorAssistant != null && textColorAssistant!.isNotEmpty) {
      params['textColorAssistant'] = textColorAssistant!;
    }
    if (userName.isNotEmpty) {
      params['userName'] = userName;
    }
    if (userEmail.isNotEmpty) {
      params['userEmail'] = userEmail;
    }
    if (chatName != 'N8N Chat') {
      params['chatName'] = chatName;
    }
    if (backgroundChatUser != '#5B9BD5') {
      params['backgroundChatUser'] = backgroundChatUser;
    }
    if (backgroundChatAssistant != '#F0F0F0') {
      params['backgroundChatAssistant'] = backgroundChatAssistant;
    }
    if (hintText != 'Digite uma mensagem...') {
      params['hintText'] = hintText;
    }
    if (footerBackgroundColor != null && footerBackgroundColor!.isNotEmpty) {
      params['footerBackgroundColor'] = footerBackgroundColor!;
    }
    if (audioButtonColor != null && audioButtonColor!.isNotEmpty) {
      params['audioButtonColor'] = audioButtonColor!;
    }
    if (imageButtonColor != null && imageButtonColor!.isNotEmpty) {
      params['imageButtonColor'] = imageButtonColor!;
    }
    if (sendButtonColor != null && sendButtonColor!.isNotEmpty) {
      params['sendButtonColor'] = sendButtonColor!;
    }
    if (headerBackgroundColor != null && headerBackgroundColor!.isNotEmpty) {
      params['headerBackgroundColor'] = headerBackgroundColor!;
    }
    if (headerTextColor != null && headerTextColor!.isNotEmpty) {
      params['headerTextColor'] = headerTextColor!;
    }
    if (enableAudio) {
      params['enableAudio'] = 'true';
    }
    if (enableImage) {
      params['enableImage'] = 'true';
    }
    if (!waitForResponse) {
      params['waitForResponse'] = 'false';
    }
    if (profileImageUrl.isNotEmpty) {
      params['profileImageUrl'] = profileImageUrl;
    }
    if (themePrimaryColor != null && themePrimaryColor!.isNotEmpty) {
      params['themePrimaryColor'] = themePrimaryColor!;
    }
    if (themeSecondaryColor != null && themeSecondaryColor!.isNotEmpty) {
      params['themeSecondaryColor'] = themeSecondaryColor!;
    }
    if (themeTertiaryColor != null && themeTertiaryColor!.isNotEmpty) {
      params['themeTertiaryColor'] = themeTertiaryColor!;
    }
    if (buttonBorderRadius != 8.0) {
      params['buttonBorderRadius'] = buttonBorderRadius.toString();
    }
    if (buttonBorderColor != null && buttonBorderColor!.isNotEmpty) {
      params['buttonBorderColor'] = buttonBorderColor!;
    }
    if (buttonTextColor != null && buttonTextColor!.isNotEmpty) {
      params['buttonTextColor'] = buttonTextColor!;
    }
    if (buttonBackgroundColor != null && buttonBackgroundColor!.isNotEmpty) {
      params['buttonBackgroundColor'] = buttonBackgroundColor!;
    }

    if (params.isEmpty) return '';

    return '?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
  }
}