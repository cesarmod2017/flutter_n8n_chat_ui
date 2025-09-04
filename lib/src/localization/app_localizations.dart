import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('pt', 'PT'), // Portuguese (Portugal)
    Locale('en', 'US'), // English
    Locale('es', 'ES'), // Spanish
  ];

  static final Map<String, Map<String, String>> _localizedStrings = {
    'pt_BR': {
      // Audio Recording
      'recording': 'Gravando...',
      'detectingMicrophones': 'Detectando microfones...',
      'noMicrophoneFound': 'Nenhum microfone encontrado',
      'selectMicrophone': 'Selecionar Microfone',
      'microphonesFound': 'microfones encontrados',
      'defaultMic': 'Padrão',
      'volume': 'Volume',
      'audioRecorded': 'Áudio gravado',

      // Chat
      'online': 'Online',
      'typeMessage': 'Digite uma mensagem...',
      'send': 'Enviar',

      // Errors
      'errorStartingRecording': 'Erro ao iniciar gravação',
      'errorStoppingRecording': 'Erro ao parar gravação',
      'errorPlayingAudio': 'Erro ao reproduzir áudio',
      'failedToStartRecording': 'Falha ao iniciar gravação',

      // Configuration
      'enableAudio': 'Habilitar Áudio',
      'enableImage': 'Habilitar Imagem',
      'waitForResponse': 'Aguardar Resposta',
      'audioDescription': 'Permite gravação e envio de áudio',
      'imageDescription': 'Permite envio de imagens',
      'waitDescription': 'Bloqueia nova mensagem até receber resposta',

      // Welcome messages
      'welcomeTitle': 'Olá seja bem vindo',
      'welcomeSubtitle':
          'Eu sou o bot que irá atender você, em que posso ajudar?',
      'chatName': 'N8N Chat',

      // Configuration Screen
      'chatConfiguration': 'Configuração do Chat',
      'restoreDefaults': 'Restaurar padrões',
      'basicSettings': 'Configurações Básicas',
      'webhookUrl': 'URL do Webhook',
      'cacheUrl': 'URL do Cache',
      'language': 'Idioma',
      'interfaceTexts': 'Textos da Interface',
      'title': 'Título',
      'subtitle': 'Subtítulo',
      'inputText': 'Texto do Input',
      'userInfo': 'Informações do Usuário',
      'userName': 'Nome do Usuário',
      'userEmail': 'Email do Usuário',
      'interfaceColors': 'Cores da Interface',
      'backgroundColor': 'Cor de Fundo',
      'textColor': 'Cor do Texto',
      'assistantTextColor': 'Cor do Texto do Assistente',
      'userBackgroundColor': 'Cor de Fundo - Usuário',
      'assistantBackgroundColor': 'Cor de Fundo - Assistente',
      'footerBackgroundColor': 'Cor de Fundo do Footer',
      'headerBackgroundColor': 'Cor de Fundo do Header',
      'headerTextColor': 'Cor do Texto do Header',
      'buttonColors': 'Cores dos Botões',
      'audioButtonColor': 'Cor do Botão de Áudio',
      'imageButtonColor': 'Cor do Botão de Imagem',
      'sendButtonColor': 'Cor do Botão de Enviar',
      'features': 'Recursos',
      'customization': 'Personalização',
      'themeMode': 'Modo do Tema',
      'light': 'Claro',
      'dark': 'Escuro',
      'system': 'Sistema',
      'profileImageUrl': 'URL da Imagem de Perfil',
      'customDataJson': 'Dados Customizados (JSON)',
      'startChat': 'Iniciar Chat',
      'previewConfiguration': 'Visualizar Configuração',
      'requiredField': 'Este campo é obrigatório',
      'invalidFormat': 'Formato inválido (use 6 caracteres hexadecimais)',
      'invalidColor': 'Cor inválida',
      'close': 'Fechar',
      'yes': 'Sim',
      'no': 'Não',
    },
    'pt_PT': {
      // Audio Recording
      'recording': 'A gravar...',
      'detectingMicrophones': 'A detectar microfones...',
      'noMicrophoneFound': 'Nenhum microfone encontrado',
      'selectMicrophone': 'Seleccionar Microfone',
      'microphonesFound': 'microfones encontrados',
      'defaultMic': 'Predefinido',
      'volume': 'Volume',
      'audioRecorded': 'Áudio gravado',

      // Chat
      'online': 'Online',
      'typeMessage': 'Escreva uma mensagem...',
      'send': 'Enviar',

      // Errors
      'errorStartingRecording': 'Erro ao iniciar gravação',
      'errorStoppingRecording': 'Erro ao parar gravação',
      'errorPlayingAudio': 'Erro ao reproduzir áudio',
      'failedToStartRecording': 'Falha ao iniciar gravação',

      // Configuration
      'enableAudio': 'Activar Áudio',
      'enableImage': 'Activar Imagem',
      'waitForResponse': 'Aguardar Resposta',
      'audioDescription': 'Permite gravação e envio de áudio',
      'imageDescription': 'Permite envio de imagens',
      'waitDescription': 'Bloqueia nova mensagem até receber resposta',

      // Welcome messages
      'welcomeTitle': 'Olá seja bem-vindo',
      'welcomeSubtitle': 'Eu sou o bot que o irá atender, em que posso ajudar?',
      'chatName': 'N8N Chat',

      // Configuration Screen
      'chatConfiguration': 'Configuração do Chat',
      'restoreDefaults': 'Restaurar predefinições',
      'basicSettings': 'Configurações Básicas',
      'webhookUrl': 'URL do Webhook',
      'cacheUrl': 'URL da Cache',
      'language': 'Idioma',
      'interfaceTexts': 'Textos da Interface',
      'title': 'Título',
      'subtitle': 'Subtítulo',
      'inputText': 'Texto do Input',
      'userInfo': 'Informações do Utilizador',
      'userName': 'Nome do Utilizador',
      'userEmail': 'Email do Utilizador',
      'interfaceColors': 'Cores da Interface',
      'backgroundColor': 'Cor de Fundo',
      'textColor': 'Cor do Texto',
      'assistantTextColor': 'Cor do Texto do Assistente',
      'userBackgroundColor': 'Cor de Fundo - Utilizador',
      'assistantBackgroundColor': 'Cor de Fundo - Assistente',
      'footerBackgroundColor': 'Cor de Fundo do Rodapé',
      'headerBackgroundColor': 'Cor de Fundo do Cabeçalho',
      'headerTextColor': 'Cor do Texto do Cabeçalho',
      'buttonColors': 'Cores dos Botões',
      'audioButtonColor': 'Cor do Botão de Áudio',
      'imageButtonColor': 'Cor do Botão de Imagem',
      'sendButtonColor': 'Cor do Botão de Enviar',
      'features': 'Recursos',
      'customization': 'Personalização',
      'themeMode': 'Modo do Tema',
      'light': 'Claro',
      'dark': 'Escuro',
      'system': 'Sistema',
      'profileImageUrl': 'URL da Imagem de Perfil',
      'customDataJson': 'Dados Personalizados (JSON)',
      'startChat': 'Iniciar Chat',
      'previewConfiguration': 'Visualizar Configuração',
      'requiredField': 'Este campo é obrigatório',
      'invalidFormat': 'Formato inválido (use 6 caracteres hexadecimais)',
      'invalidColor': 'Cor inválida',
      'close': 'Fechar',
      'yes': 'Sim',
      'no': 'Não',
    },
    'en_US': {
      // Audio Recording
      'recording': 'Recording...',
      'detectingMicrophones': 'Detecting microphones...',
      'noMicrophoneFound': 'No microphone found',
      'selectMicrophone': 'Select Microphone',
      'microphonesFound': 'microphones found',
      'defaultMic': 'Default',
      'volume': 'Volume',
      'audioRecorded': 'Audio recorded',

      // Chat
      'online': 'Online',
      'typeMessage': 'Type a message...',
      'send': 'Send',

      // Errors
      'errorStartingRecording': 'Error starting recording',
      'errorStoppingRecording': 'Error stopping recording',
      'errorPlayingAudio': 'Error playing audio',
      'failedToStartRecording': 'Failed to start recording',

      // Configuration
      'enableAudio': 'Enable Audio',
      'enableImage': 'Enable Image',
      'waitForResponse': 'Wait for Response',
      'audioDescription': 'Allows recording and sending audio',
      'imageDescription': 'Allows sending images',
      'waitDescription': 'Blocks new message until receiving response',

      // Welcome messages
      'welcomeTitle': 'Hello and welcome',
      'welcomeSubtitle': 'I am the bot that will assist you, how can I help?',
      'chatName': 'N8N Chat',

      // Configuration Screen
      'chatConfiguration': 'Chat Configuration',
      'restoreDefaults': 'Restore defaults',
      'basicSettings': 'Basic Settings',
      'webhookUrl': 'Webhook URL',
      'cacheUrl': 'Cache URL',
      'language': 'Language',
      'interfaceTexts': 'Interface Texts',
      'title': 'Title',
      'subtitle': 'Subtitle',
      'inputText': 'Input Text',
      'userInfo': 'User Information',
      'userName': 'User Name',
      'userEmail': 'User Email',
      'interfaceColors': 'Interface Colors',
      'backgroundColor': 'Background Color',
      'textColor': 'Text Color',
      'assistantTextColor': 'Assistant Text Color',
      'userBackgroundColor': 'User Background Color',
      'assistantBackgroundColor': 'Assistant Background Color',
      'footerBackgroundColor': 'Footer Background Color',
      'headerBackgroundColor': 'Header Background Color',
      'headerTextColor': 'Header Text Color',
      'buttonColors': 'Button Colors',
      'audioButtonColor': 'Audio Button Color',
      'imageButtonColor': 'Image Button Color',
      'sendButtonColor': 'Send Button Color',
      'features': 'Features',
      'customization': 'Customization',
      'themeMode': 'Theme Mode',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'profileImageUrl': 'Profile Image URL',
      'customDataJson': 'Custom Data (JSON)',
      'startChat': 'Start Chat',
      'previewConfiguration': 'Preview Configuration',
      'requiredField': 'This field is required',
      'invalidFormat': 'Invalid format (use 6 hex characters)',
      'invalidColor': 'Invalid color',
      'close': 'Close',
      'yes': 'Yes',
      'no': 'No',
    },
    'es_ES': {
      // Audio Recording
      'recording': 'Grabando...',
      'detectingMicrophones': 'Detectando micrófonos...',
      'noMicrophoneFound': 'No se encontró micrófono',
      'selectMicrophone': 'Seleccionar Micrófono',
      'microphonesFound': 'micrófonos encontrados',
      'defaultMic': 'Predeterminado',
      'volume': 'Volumen',
      'audioRecorded': 'Audio grabado',

      // Chat
      'online': 'En línea',
      'typeMessage': 'Escribe un mensaje...',
      'send': 'Enviar',

      // Errors
      'errorStartingRecording': 'Error al iniciar grabación',
      'errorStoppingRecording': 'Error al detener grabación',
      'errorPlayingAudio': 'Error al reproducir audio',
      'failedToStartRecording': 'Falló al iniciar grabación',

      // Configuration
      'enableAudio': 'Habilitar Audio',
      'enableImage': 'Habilitar Imagen',
      'waitForResponse': 'Esperar Respuesta',
      'audioDescription': 'Permite grabar y enviar audio',
      'imageDescription': 'Permite enviar imágenes',
      'waitDescription': 'Bloquea nuevo mensaje hasta recibir respuesta',

      // Welcome messages
      'welcomeTitle': 'Hola y bienvenido',
      'welcomeSubtitle': 'Soy el bot que te atenderá, ¿en qué puedo ayudarte?',
      'chatName': 'N8N Chat',

      // Configuration Screen
      'chatConfiguration': 'Configuración del Chat',
      'restoreDefaults': 'Restaurar valores por defecto',
      'basicSettings': 'Configuraciones Básicas',
      'webhookUrl': 'URL del Webhook',
      'cacheUrl': 'URL de Cache',
      'language': 'Idioma',
      'interfaceTexts': 'Textos de la Interfaz',
      'title': 'Título',
      'subtitle': 'Subtítulo',
      'inputText': 'Texto del Input',
      'userInfo': 'Información del Usuario',
      'userName': 'Nombre del Usuario',
      'userEmail': 'Email del Usuario',
      'interfaceColors': 'Colores de la Interfaz',
      'backgroundColor': 'Color de Fondo',
      'textColor': 'Color del Texto',
      'assistantTextColor': 'Color del Texto del Asistente',
      'userBackgroundColor': 'Color de Fondo - Usuario',
      'assistantBackgroundColor': 'Color de Fondo - Asistente',
      'footerBackgroundColor': 'Color de Fondo del Pie',
      'headerBackgroundColor': 'Color de Fondo del Encabezado',
      'headerTextColor': 'Color del Texto del Encabezado',
      'buttonColors': 'Colores de los Botones',
      'audioButtonColor': 'Color del Botón de Audio',
      'imageButtonColor': 'Color del Botón de Imagen',
      'sendButtonColor': 'Color del Botón de Enviar',
      'features': 'Características',
      'customization': 'Personalización',
      'themeMode': 'Modo de Tema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'system': 'Sistema',
      'profileImageUrl': 'URL de Imagen de Perfil',
      'customDataJson': 'Datos Personalizados (JSON)',
      'startChat': 'Iniciar Chat',
      'previewConfiguration': 'Vista Previa de Configuración',
      'requiredField': 'Este campo es obligatorio',
      'invalidFormat': 'Formato inválido (usar 6 caracteres hexadecimales)',
      'invalidColor': 'Color inválido',
      'close': 'Cerrar',
      'yes': 'Sí',
      'no': 'No',
    },
  };

  String translate(String key) {
    String localeKey = '${locale.languageCode}_${locale.countryCode}';

    // Fallback logic
    if (_localizedStrings[localeKey]?.containsKey(key) == true) {
      return _localizedStrings[localeKey]![key]!;
    }

    // Try language only (pt, en, es)
    String langKey =
        '${locale.languageCode}_${locale.languageCode.toUpperCase()}';
    if (locale.languageCode == 'pt') {
      langKey = 'pt_BR'; // Default Portuguese to Brazil
    } else if (locale.languageCode == 'en') {
      langKey = 'en_US'; // Default English to US
    } else if (locale.languageCode == 'es') {
      langKey = 'es_ES'; // Default Spanish to Spain
    }

    if (_localizedStrings[langKey]?.containsKey(key) == true) {
      return _localizedStrings[langKey]![key]!;
    }

    // Final fallback to pt_BR
    return _localizedStrings['pt_BR']?[key] ?? key;
  }

  // Convenience getters
  String get recording => translate('recording');
  String get detectingMicrophones => translate('detectingMicrophones');
  String get noMicrophoneFound => translate('noMicrophoneFound');
  String get selectMicrophone => translate('selectMicrophone');
  String get microphonesFound => translate('microphonesFound');
  String get defaultMic => translate('defaultMic');
  String get volume => translate('volume');
  String get audioRecorded => translate('audioRecorded');
  String get online => translate('online');
  String get typeMessage => translate('typeMessage');
  String get send => translate('send');
  String get errorStartingRecording => translate('errorStartingRecording');
  String get errorStoppingRecording => translate('errorStoppingRecording');
  String get errorPlayingAudio => translate('errorPlayingAudio');
  String get failedToStartRecording => translate('failedToStartRecording');
  String get enableAudio => translate('enableAudio');
  String get enableImage => translate('enableImage');
  String get waitForResponse => translate('waitForResponse');
  String get audioDescription => translate('audioDescription');
  String get imageDescription => translate('imageDescription');
  String get waitDescription => translate('waitDescription');
  String get welcomeTitle => translate('welcomeTitle');
  String get welcomeSubtitle => translate('welcomeSubtitle');
  String get chatName => translate('chatName');

  // Configuration Screen getters
  String get chatConfiguration => translate('chatConfiguration');
  String get restoreDefaults => translate('restoreDefaults');
  String get basicSettings => translate('basicSettings');
  String get webhookUrl => translate('webhookUrl');
  String get cacheUrl => translate('cacheUrl');
  String get language => translate('language');
  String get interfaceTexts => translate('interfaceTexts');
  String get title => translate('title');
  String get subtitle => translate('subtitle');
  String get inputText => translate('inputText');
  String get userInfo => translate('userInfo');
  String get userName => translate('userName');
  String get userEmail => translate('userEmail');
  String get interfaceColors => translate('interfaceColors');
  String get backgroundColor => translate('backgroundColor');
  String get textColor => translate('textColor');
  String get assistantTextColor => translate('assistantTextColor');
  String get userBackgroundColor => translate('userBackgroundColor');
  String get assistantBackgroundColor => translate('assistantBackgroundColor');
  String get footerBackgroundColor => translate('footerBackgroundColor');
  String get headerBackgroundColor => translate('headerBackgroundColor');
  String get headerTextColor => translate('headerTextColor');
  String get buttonColors => translate('buttonColors');
  String get audioButtonColor => translate('audioButtonColor');
  String get imageButtonColor => translate('imageButtonColor');
  String get sendButtonColor => translate('sendButtonColor');
  String get features => translate('features');
  String get customization => translate('customization');
  String get themeMode => translate('themeMode');
  String get light => translate('light');
  String get dark => translate('dark');
  String get system => translate('system');
  String get profileImageUrl => translate('profileImageUrl');
  String get customDataJson => translate('customDataJson');
  String get startChat => translate('startChat');
  String get previewConfiguration => translate('previewConfiguration');
  String get requiredField => translate('requiredField');
  String get invalidFormat => translate('invalidFormat');
  String get invalidColor => translate('invalidColor');
  String get close => translate('close');
  String get yes => translate('yes');
  String get no => translate('no');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale) ||
        ['pt', 'en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
