class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final MessageSender sender;
  final DateTime timestamp;
  final String? answer;
  final String? mimeType;
  final String? filename;
  final String? chatName;
  final String? userName;
  final String? language;
  final String? userEmail;
  final String? filePath; // Path for local files (audio/image)
  final String? fileUrl; // URL for remote files
  final String? base64; // For base64 content (audio/image)
  final String? alt; // Alt text for images
  final List<ChatButton>? buttons; // Action buttons
  final List<ChatLink>? links; // Links to display
  final ChatMeta? meta; // Meta information

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    required this.timestamp,
    this.answer,
    this.mimeType,
    this.filename,
    this.chatName,
    this.userName,
    this.language,
    this.userEmail,
    this.filePath,
    this.fileUrl,
    this.base64,
    this.alt,
    this.buttons,
    this.links,
    this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'content': content,
      if (answer != null) 'answer': answer,
      if (mimeType != null) 'mimeType': mimeType,
      if (filename != null) 'filename': filename,
      if (language != null) 'language': language,
      if (userName != null && userName!.isNotEmpty) 'userName': userName,
      if (userEmail != null && userEmail!.isNotEmpty) 'userEmail': userEmail,
      if (filePath != null) 'filePath': filePath,
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (base64 != null) 'base64': base64,
      if (alt != null) 'alt': alt,
      if (buttons != null) 'buttons': buttons!.map((b) => b.toJson()).toList(),
      if (links != null) 'links': links!.map((l) => l.toJson()).toList(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }
}

enum MessageType { text, audio, image, buttons, links }

enum MessageSender { user, assistant }

class ChatButton {
  final String title;
  final ChatButtonAction action;

  ChatButton({
    required this.title,
    required this.action,
  });

  factory ChatButton.fromJson(Map<String, dynamic> json) {
    return ChatButton(
      title: json['title'] ?? '',
      action: ChatButtonAction.fromJson(json['action'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'action': action.toJson(),
    };
  }
}

class ChatButtonAction {
  final String type; // 'reply' or 'link'
  final String value;

  ChatButtonAction({
    required this.type,
    required this.value,
  });

  factory ChatButtonAction.fromJson(Map<String, dynamic> json) {
    return ChatButtonAction(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

class ChatLink {
  final String title;
  final String url;
  final String? kind; // 'external', 'deep_link', 'download'
  final String? open; // 'external', 'in_app'
  final String? description;
  final String? previewImageBase64;
  final String? expiresAt;
  final String? trackId;

  ChatLink({
    required this.title,
    required this.url,
    this.kind,
    this.open,
    this.description,
    this.previewImageBase64,
    this.expiresAt,
    this.trackId,
  });

  factory ChatLink.fromJson(Map<String, dynamic> json) {
    return ChatLink(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      kind: json['kind'],
      open: json['open'],
      description: json['description'],
      previewImageBase64: json['previewImageBase64'],
      expiresAt: json['expiresAt'],
      trackId: json['trackId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      if (kind != null) 'kind': kind,
      if (open != null) 'open': open,
      if (description != null) 'description': description,
      if (previewImageBase64 != null) 'previewImageBase64': previewImageBase64,
      if (expiresAt != null) 'expiresAt': expiresAt,
      if (trackId != null) 'trackId': trackId,
    };
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    try {
      final expiry = DateTime.parse(expiresAt!);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return false;
    }
  }
}

class ChatMeta {
  final bool allowButtons;
  final String priority; // 'low', 'normal', 'high'
  final bool repliesAllowed;

  ChatMeta({
    required this.allowButtons,
    required this.priority,
    required this.repliesAllowed,
  });

  factory ChatMeta.fromJson(Map<String, dynamic> json) {
    return ChatMeta(
      allowButtons: json['allowButtons'] ?? true,
      priority: json['priority'] ?? 'normal',
      repliesAllowed: json['repliesAllowed'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowButtons': allowButtons,
      'priority': priority,
      'repliesAllowed': repliesAllowed,
    };
  }
}

class ApiResponse {
  final List<ChatMessage> messages;
  final List<ChatButton>? buttons;
  final List<ChatLink>? links;
  final ChatMeta? meta;

  ApiResponse({
    required this.messages,
    this.buttons,
    this.links,
    this.meta,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final List<ChatMessage> messages = [];
    
    if (json['messages'] != null) {
      for (final messageJson in json['messages']) {
        final message = _parseMessageFromJson(messageJson);
        if (message != null) messages.add(message);
      }
    }

    final List<ChatButton>? buttons = json['buttons'] != null 
        ? (json['buttons'] as List).map((b) => ChatButton.fromJson(b)).toList()
        : null;

    final List<ChatLink>? links = json['links'] != null 
        ? (json['links'] as List).map((l) => ChatLink.fromJson(l)).toList()
        : null;

    return ApiResponse(
      messages: messages,
      buttons: buttons,
      links: links,
      meta: json['meta'] != null ? ChatMeta.fromJson(json['meta']) : null,
    );
  }

  static ChatMessage? _parseMessageFromJson(Map<String, dynamic> json) {
    final String type = json['type'] ?? '';
    final String content = json['text'] ?? json['base64'] ?? '';
    
    if (content.isEmpty) return null;

    MessageType messageType;
    switch (type) {
      case 'text':
        messageType = MessageType.text;
        break;
      case 'audio':
        messageType = MessageType.audio;
        break;
      case 'image':
        messageType = MessageType.image;
        break;
      default:
        messageType = MessageType.text;
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['text'] ?? '',
      type: messageType,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      base64: json['base64'],
      mimeType: json['mime'],
      alt: json['alt'],
    );
  }
}