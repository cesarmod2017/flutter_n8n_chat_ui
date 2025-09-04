import 'package:flutter/material.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';
import 'audio_recorder_widget.dart';
import 'image_picker_widget.dart';
import 'chat_buttons_bubble.dart';
import 'chat_links_bubble.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Color textColor;
  final Color textColorAssistant;
  final Color userBubbleColor;
  final Color assistantBubbleColor;
  final String profileImageUrl;
  final String chatName;
  final Widget? customAvatar;
  final Function(ChatMessage)? onMessageTap;
  final Function(ChatMessage)? onMessageLongPress;
  final Function(String)? onButtonPressed; // For handling button presses
  final double buttonBorderRadius;
  final String? buttonBorderColor;
  final String? buttonTextColor;
  final String? buttonBackgroundColor;

  const MessageBubble({
    super.key,
    required this.message,
    required this.textColor,
    required this.textColorAssistant,
    required this.userBubbleColor,
    required this.assistantBubbleColor,
    required this.profileImageUrl,
    required this.chatName,
    this.customAvatar,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onButtonPressed,
    this.buttonBorderRadius = 8.0,
    this.buttonBorderColor,
    this.buttonTextColor,
    this.buttonBackgroundColor,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'AI';
    
    List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].length >= 2 ? words[0].substring(0, 2).toUpperCase() : words[0].toUpperCase();
    }
    
    String initials = '';
    for (int i = 0; i < words.length && initials.length < 2; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    return initials.isEmpty ? 'AI' : initials;
  }

  Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    
    try {
      String cleanColor = colorString.replaceAll('#', '');
      if (cleanColor.isEmpty) return null;
      if (cleanColor.length == 6) cleanColor = 'FF$cleanColor';
      if (cleanColor.length == 8) {
        return Color(int.parse(cleanColor, radix: 16));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final timeFormat = DateFormat('HH:mm');
    
    // Handle special message types (buttons, links) that don't use bubbles
    if (message.type == MessageType.buttons && message.buttons != null) {
      return ChatButtonsBubble(
        buttons: message.buttons!,
        backgroundColor: assistantBubbleColor,
        textColor: textColorAssistant,
        onButtonPressed: onButtonPressed,
        borderRadius: buttonBorderRadius,
        buttonBorderColor: _parseColor(buttonBorderColor),
        buttonTextColor: _parseColor(buttonTextColor),
        buttonBackgroundColor: _parseColor(buttonBackgroundColor),
      );
    }
    
    if (message.type == MessageType.links && message.links != null) {
      return ChatLinksBubble(
        links: message.links!,
        backgroundColor: assistantBubbleColor,
        textColor: textColorAssistant,
      );
    }
    
    return GestureDetector(
      onTap: onMessageTap != null ? () => onMessageTap!(message) : null,
      onLongPress: onMessageLongPress != null ? () => onMessageLongPress!(message) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              customAvatar ?? CircleAvatar(
                radius: 16,
                backgroundColor: assistantBubbleColor,
                child: Text(
                  _getInitials(chatName),
                  style: TextStyle(
                    color: textColorAssistant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? userBubbleColor : assistantBubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(6),
                    bottomRight: isUser ? const Radius.circular(6) : const Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content based on message type
                    if (message.type == MessageType.audio) ...[
                      AudioPlayerWidget(
                        audioPath: message.filePath ?? message.fileUrl ?? '',
                        buttonColor: isUser ? Colors.white : textColorAssistant,
                        isFromUser: isUser,
                      ),
                    ] else if (message.type == MessageType.image) ...[
                      ImageMessageWidget(
                        imagePath: message.filePath ?? message.fileUrl ?? '',
                        caption: message.content.isNotEmpty ? message.content : null,
                        isUrl: message.fileUrl != null,
                      ),
                    ] else ...[
                      SelectableText(
                        message.content,
                        style: TextStyle(
                          color: isUser ? Colors.white : textColorAssistant,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timeFormat.format(message.timestamp),
                          style: TextStyle(
                            color: isUser ? Colors.white70 : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.done_all,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: userBubbleColor,
                child: message.userName != null && message.userName!.isNotEmpty
                    ? Text(
                        _getInitials(message.userName!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 18,
                        color: Colors.white,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}