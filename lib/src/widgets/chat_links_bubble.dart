import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/message.dart';

class ChatLinksBubble extends StatelessWidget {
  final List<ChatLink> links;
  final Color backgroundColor;
  final Color textColor;

  const ChatLinksBubble({
    super.key,
    required this.links,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    // Check if it's mobile platform
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Mobile breakpoint
    
    Widget linksContainer = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: links.map((link) => _buildLink(context, link)).toList(),
      ),
    );

    // For non-mobile platforms, constrain width
    if (!isMobile) {
      linksContainer = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: linksContainer,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: linksContainer,
    );
  }

  Widget _buildLink(BuildContext context, ChatLink link) {
    final isFirstLink = links.indexOf(link) == 0;
    final isExpired = link.isExpired;
    
    return Container(
      margin: EdgeInsets.only(
        top: isFirstLink ? 0 : 12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: isExpired ? null : () => _handleLinkTap(link),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isExpired 
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isExpired 
                  ? Colors.grey.withValues(alpha: 0.1)
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview image if available
                if (link.previewImageBase64 != null) ...[
                  _buildPreviewImage(link.previewImageBase64!),
                  const SizedBox(height: 8),
                ],
                
                // Title and URL row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          SelectableText(
                            link.title,
                            style: TextStyle(
                              color: isExpired ? Colors.grey : textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              decoration: isExpired ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          
                          // URL
                          const SizedBox(height: 2),
                          SelectableText(
                            _formatUrl(link.url),
                            style: TextStyle(
                              color: isExpired 
                                  ? Colors.grey 
                                  : Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              decoration: isExpired ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Link icon
                    Icon(
                      _getLinkIcon(link.kind),
                      size: 20,
                      color: isExpired 
                          ? Colors.grey 
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                
                // Description if available
                if (link.description != null && link.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  SelectableText(
                    link.description!,
                    style: TextStyle(
                      color: isExpired ? Colors.grey : textColor.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
                
                // Expiry warning if expired
                if (isExpired) ...[
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(
                        Icons.warning,
                        size: 14,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Link expired',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String base64Image) {
    try {
      final imageBytes = base64Decode(base64Image);
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          child: Image.memory(
            Uint8List.fromList(imageBytes),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 32,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 32,
        ),
      );
    }
  }

  String _formatUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : url;
    } catch (e) {
      return url;
    }
  }

  IconData _getLinkIcon(String? kind) {
    switch (kind) {
      case 'external':
        return Icons.open_in_new;
      case 'deep_link':
        return Icons.launch;
      case 'download':
        return Icons.download;
      default:
        return Icons.link;
    }
  }

  Future<void> _handleLinkTap(ChatLink link) async {
    try {
      final uri = Uri.parse(link.url);
      
      LaunchMode mode;
      switch (link.open) {
        case 'in_app':
          mode = LaunchMode.inAppWebView;
          break;
        case 'external':
        default:
          mode = LaunchMode.externalApplication;
          break;
      }
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        print('Could not launch ${link.url}');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}