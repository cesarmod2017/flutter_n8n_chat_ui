import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/message.dart';
import '../models/chat_config.dart';
import 'image_service.dart';
import 'audio_service.dart';

class ChatService {
  final ChatConfig config;
  
  ChatService({required this.config});

  Future<List<ChatMessage>?> sendMessage(ChatMessage message) async {
    try {
      Map<String, dynamic> messageData = {
        ...message.toJson(),
        if (config.customData != null) ...config.customData!,
      };
      
      // Add base64 data for images
      if (message.type == MessageType.image && message.filePath != null) {
        print('Processing image attachment: ${message.filePath}');
        final imageService = ImageService();
        final imageFile = XFile(message.filePath!);
        final imageData = await imageService.getImageDataForApi(imageFile);
        if (imageData != null) {
          print('Image converted to base64, filename: ${imageData['filename']}, size: ${imageData['size']} bytes');
          // Replace the content with base64 and add metadata
          messageData['content'] = imageData['content']; // Pure base64
          messageData['mimeType'] = imageData['mimeType']; // Content type
          messageData['filename'] = imageData['filename']; // File name with extension
          messageData['fileSize'] = imageData['size'];
        } else {
          print('Failed to convert image to base64');
        }
      }
      
      // Add base64 data for audio
      if (message.type == MessageType.audio && message.filePath != null) {
        print('Processing audio attachment: ${message.filePath}');
        final audioService = AudioService();
        final audioData = await audioService.getAudioDataForApi(message.filePath!);
        if (audioData != null) {
          print('Audio converted to base64, filename: ${audioData['filename']}, size: ${audioData['size']} bytes');
          // Replace the content with base64 and add metadata
          messageData['content'] = audioData['content']; // Pure base64
          messageData['mimeType'] = audioData['mimeType']; // Content type  
          messageData['filename'] = audioData['filename']; // File name with extension
          messageData['fileSize'] = audioData['size'];
        } else {
          print('Failed to convert audio to base64');
        }
      }
      
      final response = await http.post(
        Uri.parse(config.webhookUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(messageData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        print('Parsed response type: ${responseData.runtimeType}');
        
        List<ChatMessage> resultMessages = [];
        
        if (responseData is List && responseData.isNotEmpty) {
          // Process new API format - array of response items
          for (final responseItem in responseData) {
            if (responseItem is Map<String, dynamic>) {
              final apiResponse = ApiResponse.fromJson(responseItem);
              
              // Add all messages from this response
              resultMessages.addAll(apiResponse.messages);
              
              // If there are buttons, create a buttons message
              if (apiResponse.buttons != null && apiResponse.buttons!.isNotEmpty) {
                final buttonsMessage = ChatMessage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  content: '', // Empty content for buttons-only message
                  type: MessageType.buttons,
                  sender: MessageSender.assistant,
                  timestamp: DateTime.now(),
                  buttons: apiResponse.buttons,
                  meta: apiResponse.meta,
                );
                resultMessages.add(buttonsMessage);
              }
              
              // If there are links, create a links message
              if (apiResponse.links != null && apiResponse.links!.isNotEmpty) {
                final linksMessage = ChatMessage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  content: '', // Empty content for links-only message
                  type: MessageType.links,
                  sender: MessageSender.assistant,
                  timestamp: DateTime.now(),
                  links: apiResponse.links,
                  meta: apiResponse.meta,
                );
                resultMessages.add(linksMessage);
              }
            }
          }
        }
        else if (responseData is Map<String, dynamic>) {
          // Handle single response object
          if (responseData.containsKey('output')) {
            // Old format fallback
            final output = responseData['output'].toString();
            final textMessage = ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: output,
              type: MessageType.text,
              sender: MessageSender.assistant,
              timestamp: DateTime.now(),
            );
            resultMessages.add(textMessage);
          } else {
            // New format
            final apiResponse = ApiResponse.fromJson(responseData);
            resultMessages.addAll(apiResponse.messages);
            
            if (apiResponse.buttons != null && apiResponse.buttons!.isNotEmpty) {
              final buttonsMessage = ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                content: '',
                type: MessageType.buttons,
                sender: MessageSender.assistant,
                timestamp: DateTime.now(),
                buttons: apiResponse.buttons,
                meta: apiResponse.meta,
              );
              resultMessages.add(buttonsMessage);
            }
            
            if (apiResponse.links != null && apiResponse.links!.isNotEmpty) {
              final linksMessage = ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                content: '',
                type: MessageType.links,
                sender: MessageSender.assistant,
                timestamp: DateTime.now(),
                links: apiResponse.links,
                meta: apiResponse.meta,
              );
              resultMessages.add(linksMessage);
            }
          }
        }
        
        print('Processed ${resultMessages.length} messages from response');
        return resultMessages.isNotEmpty ? resultMessages : null;
      }
      
      print('No valid response found');
      return null;
    } catch (e) {
      print('Error sending message: $e');
      print('Response body type: ${e.runtimeType}');
      return null;
    }
  }

  Future<List<ChatMessage>> fetchMessageHistory({int? limit, int? offset}) async {
    if (config.cacheUrl == null || config.cacheUrl!.isEmpty || config.userEmail.isEmpty) {
      return [];
    }

    try {
      final key = 'chat_${config.userEmail}';
      final uri = Uri.parse('${config.cacheUrl}?key=$key');
      
      print('Fetching message history from: $uri');
      
      final response = await http.get(uri);
      
      print('Cache API response status: ${response.statusCode}');
      print('Cache API response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData.containsKey('messages')) {
          final List<dynamic> messages = responseData['messages'];
          
          List<ChatMessage> chatMessages = [];
          
          // Apply pagination - get all messages first (reversed for chronological order)
          List<ChatMessage> allMessages = [];
          for (int i = messages.length - 1; i >= 0; i--) {
            final messageData = messages[i];
            if (messageData is Map<String, dynamic>) {
              final convertedMessages = _convertApiMessageToChatMessage(messageData);
              allMessages.addAll(convertedMessages);
            }
          }
          
          // Apply pagination with limit and offset
          int startIndex = offset ?? 0;
          int endIndex = limit != null ? (startIndex + limit) : allMessages.length;
          
          // Ensure we don't exceed array bounds
          startIndex = startIndex.clamp(0, allMessages.length);
          endIndex = endIndex.clamp(0, allMessages.length);
          
          // For chat messages, we want the most recent messages first
          // so we reverse the slice to get the latest messages
          if (startIndex < endIndex) {
            // Get messages from the end (most recent) based on pagination
            int reverseStart = (allMessages.length - endIndex).clamp(0, allMessages.length);
            int reverseEnd = (allMessages.length - startIndex).clamp(0, allMessages.length);
            
            if (reverseStart < reverseEnd) {
              chatMessages = allMessages.sublist(reverseStart, reverseEnd);
            }
          }
          
          print('Loaded ${chatMessages.length} messages from cache');
          return chatMessages;
        }
      } else {
        print('Failed to fetch message history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching message history: $e');
    }
    
    return [];
  }

  List<ChatMessage> _convertApiMessageToChatMessage(Map<String, dynamic> messageData) {
    try {
      final String type = messageData['type'] ?? '';
      final Map<String, dynamic> data = messageData['data'] ?? {};
      final String content = data['content'] ?? '';
      
      if (content.isEmpty) {
        return [];
      }
      
      MessageSender sender;
      if (type == 'ai') {
        sender = MessageSender.assistant;
      } else if (type == 'human') {
        sender = MessageSender.user;
      } else {
        return [];
      }
      
      // Check if content is JSON (for AI messages with response format)
      if (sender == MessageSender.assistant && _isValidJson(content)) {
        try {
          final dynamic parsedJson = jsonDecode(content);
          
          // Check if it has the expected "response" structure
          if (parsedJson is Map<String, dynamic> && parsedJson.containsKey('response')) {
            final responseData = parsedJson['response'] as Map<String, dynamic>;
            return _processResponseFormat(responseData, sender);
          }
          
          // Try processing as direct API response format
          return _processJsonContent(parsedJson, sender);
        } catch (e) {
          print('Error parsing JSON content: $e');
          // Fallback to text message
          return [ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: content,
            type: MessageType.text,
            sender: sender,
            timestamp: DateTime.now(),
          )];
        }
      }
      
      // Regular text message (for human messages or non-JSON AI messages)
      final textMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: MessageType.text,
        sender: sender,
        timestamp: DateTime.now(),
      );
      return [textMessage];
    } catch (e) {
      print('Error converting API message: $e');
      return [];
    }
  }
  
  List<ChatMessage> _processResponseFormat(Map<String, dynamic> responseData, MessageSender sender) {
    List<ChatMessage> resultMessages = [];
    final timestamp = DateTime.now();
    int idOffset = 0;
    
    // Process messages array
    if (responseData.containsKey('messages')) {
      final messages = responseData['messages'] as List<dynamic>?;
      if (messages != null) {
        for (final msg in messages) {
          if (msg is Map<String, dynamic>) {
            final msgType = msg['type'] as String?;
            
            if (msgType == 'text') {
              final text = msg['text'] as String? ?? '';
              if (text.isNotEmpty) {
                resultMessages.add(ChatMessage(
                  id: (timestamp.millisecondsSinceEpoch + idOffset++).toString(),
                  content: text,
                  type: MessageType.text,
                  sender: sender,
                  timestamp: timestamp,
                ));
              }
            }
            // Add handling for audio and image types if needed
          }
        }
      }
    }
    
    // Process buttons
    if (responseData.containsKey('buttons')) {
      final buttons = responseData['buttons'] as List<dynamic>?;
      if (buttons != null && buttons.isNotEmpty) {
        List<ChatButton> chatButtons = [];
        for (final btn in buttons) {
          if (btn is Map<String, dynamic>) {
            try {
              chatButtons.add(ChatButton.fromJson(btn));
            } catch (e) {
              print('Error parsing button: $e');
            }
          }
        }
        
        if (chatButtons.isNotEmpty) {
          resultMessages.add(ChatMessage(
            id: (timestamp.millisecondsSinceEpoch + idOffset++).toString(),
            content: '',
            type: MessageType.buttons,
            sender: sender,
            timestamp: timestamp,
            buttons: chatButtons,
            meta: responseData.containsKey('meta') 
                ? ChatMeta.fromJson(responseData['meta'] as Map<String, dynamic>)
                : null,
          ));
        }
      }
    }
    
    // Process links
    if (responseData.containsKey('links')) {
      final links = responseData['links'] as List<dynamic>?;
      if (links != null && links.isNotEmpty) {
        List<ChatLink> chatLinks = [];
        for (final link in links) {
          if (link is Map<String, dynamic>) {
            try {
              chatLinks.add(ChatLink.fromJson(link));
            } catch (e) {
              print('Error parsing link: $e');
            }
          }
        }
        
        if (chatLinks.isNotEmpty) {
          resultMessages.add(ChatMessage(
            id: (timestamp.millisecondsSinceEpoch + idOffset++).toString(),
            content: '',
            type: MessageType.links,
            sender: sender,
            timestamp: timestamp,
            links: chatLinks,
            meta: responseData.containsKey('meta')
                ? ChatMeta.fromJson(responseData['meta'] as Map<String, dynamic>)
                : null,
          ));
        }
      }
    }
    
    return resultMessages;
  }

  bool _isValidJson(String content) {
    if (!content.trim().startsWith('{') && !content.trim().startsWith('[')) {
      return false;
    }
    try {
      jsonDecode(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<ChatMessage> _processJsonContent(dynamic jsonData, MessageSender sender) {
    List<ChatMessage> messages = [];
    final timestamp = DateTime.now();
    
    if (jsonData is Map<String, dynamic>) {
      // Single response object
      final apiResponse = ApiResponse.fromJson(jsonData);
      
      // Add text messages
      messages.addAll(apiResponse.messages);
      
      // Add buttons message if present
      if (apiResponse.buttons != null && apiResponse.buttons!.isNotEmpty) {
        messages.add(ChatMessage(
          id: timestamp.millisecondsSinceEpoch.toString(),
          content: '',
          type: MessageType.buttons,
          sender: sender,
          timestamp: timestamp,
          buttons: apiResponse.buttons,
          meta: apiResponse.meta,
        ));
      }
      
      // Add links message if present
      if (apiResponse.links != null && apiResponse.links!.isNotEmpty) {
        messages.add(ChatMessage(
          id: (timestamp.millisecondsSinceEpoch + 1).toString(),
          content: '',
          type: MessageType.links,
          sender: sender,
          timestamp: timestamp,
          links: apiResponse.links,
          meta: apiResponse.meta,
        ));
      }
    } else if (jsonData is List) {
      // Array of response objects
      for (final item in jsonData) {
        if (item is Map<String, dynamic>) {
          messages.addAll(_processJsonContent(item, sender));
        }
      }
    }
    
    return messages;
  }
}