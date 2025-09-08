import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import '../models/chat_config.dart';
import '../services/chat_service.dart';
import '../localization/localization_helper.dart';
import 'message_bubble.dart';
import 'chat_input_field.dart';
import 'animated_loading_dots.dart';

class N8NChatWidget extends StatefulWidget {
  final ChatConfig config;
  final Widget Function(ChatMessage)? messageBuilder;
  final Function(ChatMessage)? onMessageSent;
  final Function(ChatMessage)? onMessageReceived;
  final Widget? headerWidget;
  final Widget? footerWidget;
  final bool showHeader;

  const N8NChatWidget({
    super.key,
    required this.config,
    this.messageBuilder,
    this.onMessageSent,
    this.onMessageReceived,
    this.headerWidget,
    this.footerWidget,
    this.showHeader = true,
  });

  @override
  State<N8NChatWidget> createState() => _N8NChatWidgetState();
}

class _N8NChatWidgetState extends State<N8NChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  late final ChatService _chatService;
  bool _isLoading = false;
  bool _showTypingIndicator = false;
  bool _showScrollToBottomButton = false;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  int _currentOffset = 0;
  static const int _pageSize = 10;
  late final _localizations = LocalizationHelper.getLocalizations(widget.config.language);

  String _getLocalizedText(String key) {
    return _localizations.translate(key);
  }

  void _processApiResponse(List<ChatMessage>? responseMessages) {
    if (responseMessages == null || responseMessages.isEmpty) return;
    
    setState(() {
      _messages.addAll(responseMessages);
      _showTypingIndicator = false;
    });
    
    // Notify callbacks for each message
    for (final message in responseMessages) {
      if (widget.onMessageReceived != null) {
        widget.onMessageReceived!(message);
      }
    }
    
    _scrollToBottom();
  }
  
  void _handleButtonPress(String buttonValue) {
    // Create a user message from the button press
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: buttonValue,
      type: MessageType.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      userName: widget.config.userName,
      language: widget.config.language,
      userEmail: widget.config.userEmail,
    );
    
    _processUserMessage(userMessage);
  }
  
  void _processUserMessage(ChatMessage userMessage) async {
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _showTypingIndicator = true;
    });

    _scrollToBottom();
    
    if (widget.onMessageSent != null) {
      widget.onMessageSent!(userMessage);
    }

    final responseMessages = await _chatService.sendMessage(userMessage);
    
    setState(() {
      _isLoading = false;
    });

    _processApiResponse(responseMessages);
  }

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(config: widget.config);
    _scrollController.addListener(_onScroll);
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _loadInitialMessages() async {
    if (widget.config.cacheUrl != null && widget.config.cacheUrl!.isNotEmpty) {
      await _loadMessageHistory();
    } else {
      _addWelcomeMessages();
    }
  }

  Future<void> _loadMessageHistory() async {
    try {
      // Load only the last 10 messages initially
      final cachedMessages = await _chatService.fetchMessageHistory(
        limit: _pageSize,
        offset: _currentOffset,
      );
      
      if (cachedMessages.isNotEmpty) {
        setState(() {
          _messages.clear();
          _messages.addAll(cachedMessages);
          _currentOffset = cachedMessages.length;
          _hasMoreMessages = cachedMessages.length == _pageSize;
        });
        
        // Multiple attempts to ensure scroll happens after cache load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(animated: false);
        });
        
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients) {
            _scrollToBottom(animated: false);
          }
        });
        
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _scrollController.hasClients) {
            _scrollToBottom(animated: false);
          }
        });
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted && _scrollController.hasClients) {
            _scrollToBottom(animated: false);
          }
        });
      } else {
        _addWelcomeMessages();
        _hasMoreMessages = false;
      }
    } catch (e) {
      print('Error loading message history: $e');
      _addWelcomeMessages();
      _hasMoreMessages = false;
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMoreMessages) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final moreMessages = await _chatService.fetchMessageHistory(
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (moreMessages.isNotEmpty) {
        setState(() {
          // Preserve scroll position by remembering current position
          final currentScrollPosition = _scrollController.position.pixels;
          
          // Insert older messages at the beginning
          _messages.insertAll(0, moreMessages);
          _currentOffset += moreMessages.length;
          _hasMoreMessages = moreMessages.length == _pageSize;
          
          // Restore scroll position after adding messages
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              // Calculate the new position to maintain the user's view
              final newPosition = currentScrollPosition + 
                (moreMessages.length * 80.0); // Approximate message height
              _scrollController.jumpTo(newPosition.clamp(
                0.0, 
                _scrollController.position.maxScrollExtent
              ));
            }
          });
        });
      } else {
        setState(() {
          _hasMoreMessages = false;
        });
      }
    } catch (e) {
      print('Error loading more messages: $e');
      setState(() {
        _hasMoreMessages = false;
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _addWelcomeMessages() {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: widget.config.title.isEmpty ? _getLocalizedText('welcomeTitle') : widget.config.title,
      type: MessageType.text,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      chatName: widget.config.chatName,
      language: widget.config.language,
    );

    final subtitleMessage = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: widget.config.subtitle.isEmpty ? _getLocalizedText('welcomeSubtitle') : widget.config.subtitle,
      type: MessageType.text,
      sender: MessageSender.assistant,
      timestamp: DateTime.now().add(const Duration(milliseconds: 500)),
      chatName: widget.config.chatName,
      language: widget.config.language,
    );

    setState(() {
      _messages.addAll([welcomeMessage, subtitleMessage]);
    });
    
    // Ensure scroll to bottom after adding welcome messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
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

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty || (widget.config.waitForResponse && _isLoading)) return;

    final messageText = _textController.text.trim();
    _textController.clear();
    
    // Keep focus on the text field for immediate next message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.requestFocus();
      }
    });

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText,
      type: MessageType.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      userName: widget.config.userName,
      language: widget.config.language,
      userEmail: widget.config.userEmail,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
      _showTypingIndicator = true;
    });

    _scrollToBottom();
    
    if (widget.onMessageSent != null) {
      widget.onMessageSent!(userMessage);
    }

    final responseMessages = await _chatService.sendMessage(userMessage);
    
    setState(() {
      _isLoading = false;
    });

    _processApiResponse(responseMessages);
    _scrollToBottom();
    
    // Ensure focus is restored after conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.requestFocus();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final position = _scrollController.position;
    final isAtBottom = position.pixels >= position.maxScrollExtent - 50; // 50px threshold
    final isAtTop = position.pixels <= 50; // 50px threshold from top
    
    // Update scroll to bottom button visibility
    if (_showScrollToBottomButton != !isAtBottom) {
      setState(() {
        _showScrollToBottomButton = !isAtBottom;
      });
    }
    
    // Load more messages when scrolling to top
    if (isAtTop && _hasMoreMessages && !_isLoadingMore) {
      _loadMoreMessages();
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (animated) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      // For non-animated scroll (like after cache load), try multiple methods
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          try {
            final maxExtent = _scrollController.position.maxScrollExtent;
            if (maxExtent > 0) {
              _scrollController.jumpTo(maxExtent);
            }
          } catch (e) {
            // Fallback to delayed scroll
            Future.delayed(const Duration(milliseconds: 50), () {
              if (mounted && _scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
          }
        }
      });
    }
  }

  void _handleAudioMessage(String audioPath) async {
    if (widget.config.waitForResponse && _isLoading) return;

    // Generate proper filename for audio
    final audioFileName = audioPath.split('/').last.split('\\').last;
    
    final audioMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '', // Empty content to avoid showing text below player
      type: MessageType.audio,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      userName: widget.config.userName,
      language: widget.config.language,
      userEmail: widget.config.userEmail,
      filePath: audioPath,
      filename: audioFileName,
    );

    _processUserMessage(audioMessage);



    setState(() {
      _isLoading = false;
    });
    _scrollToBottom();
    
    // Ensure focus is restored after audio conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.requestFocus();
      }
    });
  }

  void _handleImageMessage(XFile image) async {
    if (widget.config.waitForResponse && _isLoading) return;

    final imageMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '', // Empty content to avoid showing text below image
      type: MessageType.image,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      userName: widget.config.userName,
      language: widget.config.language,
      userEmail: widget.config.userEmail,
      filePath: image.path,
      filename: image.name,
    );

    setState(() {
      _messages.add(imageMessage);
      _isLoading = true;
      _showTypingIndicator = true;
    });

    _scrollToBottom();

    if (widget.onMessageSent != null) {
      widget.onMessageSent!(imageMessage);
    }

    _processUserMessage(imageMessage);
    
    // Ensure focus is restored after image conversation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_textFieldFocusNode.hasFocus) {
        _textFieldFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use theme colors when not specified
    final backgroundColor = _parseColor(widget.config.backgroundColor) ?? theme.colorScheme.surface;
    final textColor = _parseColor(widget.config.textColor) ?? theme.colorScheme.onSurface;
    final textColorAssistant = _parseColor(widget.config.textColorAssistant) ?? theme.colorScheme.onSurfaceVariant;
    final headerBackgroundColor = _parseColor(widget.config.headerBackgroundColor) ?? theme.colorScheme.primary;
    final headerTextColor = _parseColor(widget.config.headerTextColor) ?? theme.colorScheme.onPrimary;
    final userBubbleColor = _parseColor(widget.config.backgroundChatUser) ?? theme.colorScheme.primaryContainer;
    final assistantBubbleColor = _parseColor(widget.config.backgroundChatAssistant) ?? theme.colorScheme.secondaryContainer;
    final footerBackgroundColor = _parseColor(widget.config.footerBackgroundColor) ?? theme.colorScheme.surface;
    final sendButtonColor = _parseColor(widget.config.sendButtonColor) ?? theme.colorScheme.primary;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: (widget.showHeader && widget.config.showAppBar) ? AppBar(
        backgroundColor: headerBackgroundColor,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: widget.headerWidget ?? Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                widget.config.chatName.substring(0, 2).toUpperCase(),
                style: TextStyle(
                  color: headerTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.config.chatName,
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getLocalizedText('online'),
                    style: TextStyle(
                      color: headerTextColor.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : null,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + 
                        (_showTypingIndicator ? 1 : 0) + 
                        (_isLoadingMore && _hasMoreMessages ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading more indicator at the top
                if (index == 0 && _isLoadingMore && _hasMoreMessages) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Carregando mensagens...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                // Adjust index for messages array
                final messageIndex = index - (_isLoadingMore && _hasMoreMessages ? 1 : 0);
                
                // Typing indicator at the bottom
                if (messageIndex == _messages.length && _showTypingIndicator) {
                  return TypingIndicator(
                    bubbleColor: assistantBubbleColor,
                    textColor: textColorAssistant,
                    chatName: widget.config.chatName,
                    profileImageUrl: widget.config.profileImageUrl,
                  );
                }
                
                // Regular message
                if (messageIndex < _messages.length) {
                  final message = _messages[messageIndex];
                  
                  if (widget.messageBuilder != null) {
                    return widget.messageBuilder!(message);
                  }
                  
                  return MessageBubble(
                    message: message,
                    textColor: textColor,
                    textColorAssistant: textColorAssistant,
                    userBubbleColor: userBubbleColor,
                    assistantBubbleColor: assistantBubbleColor,
                    profileImageUrl: widget.config.profileImageUrl,
                    chatName: widget.config.chatName,
                    onButtonPressed: _handleButtonPress,
                    buttonBorderRadius: widget.config.buttonBorderRadius,
                    buttonBorderColor: widget.config.buttonBorderColor,
                    buttonTextColor: widget.config.buttonTextColor,
                    buttonBackgroundColor: widget.config.buttonBackgroundColor,
                  );
                }
                
                // Fallback empty container
                return const SizedBox.shrink();
              },
            ),
          ),
          widget.footerWidget ?? ChatInputField(
            controller: _textController,
            focusNode: _textFieldFocusNode,
            hintText: widget.config.hintText,
            backgroundColor: footerBackgroundColor,
            sendButtonColor: sendButtonColor,
            onSend: _sendMessage,
            isLoading: _isLoading,
            enableAudio: widget.config.enableAudio,
            enableImage: widget.config.enableImage,
            waitForResponse: widget.config.waitForResponse,
            language: widget.config.language,
            audioButtonColor: _parseColor(widget.config.audioButtonColor),
            imageButtonColor: _parseColor(widget.config.imageButtonColor),
            onAudioRecorded: (audioPath) {
              _handleAudioMessage(audioPath);
            },
            onImageSelected: (image) {
              _handleImageMessage(image);
            },
          ),
        ],
      ),
      floatingActionButton: _showScrollToBottomButton
          ? FloatingActionButton.small(
              onPressed: () => _scrollToBottom(),
              backgroundColor: sendButtonColor,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}