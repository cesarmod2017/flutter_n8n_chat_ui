import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/message.dart';

class ChatButtonsBubble extends StatelessWidget {
  final List<ChatButton> buttons;
  final Color backgroundColor;
  final Color textColor;
  final Function(String)? onButtonPressed;
  final double borderRadius;
  final Color? buttonBorderColor;
  final Color? buttonTextColor;
  final Color? buttonBackgroundColor;

  const ChatButtonsBubble({
    super.key,
    required this.buttons,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.onButtonPressed,
    this.borderRadius = 8.0,
    this.buttonBorderColor,
    this.buttonTextColor,
    this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Check if it's mobile platform
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Mobile breakpoint
    
    Widget buttonContainer = Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((button) => _buildButton(context, button)).toList(),
      ),
    );

    // For non-mobile platforms, constrain width
    if (!isMobile) {
      buttonContainer = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: buttonContainer,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: buttonContainer,
    );
  }

  Widget _buildButton(BuildContext context, ChatButton button) {
    final isFirstButton = buttons.indexOf(button) == 0;
    final isLastButton = buttons.indexOf(button) == buttons.length - 1;
    
    return Container(
      margin: EdgeInsets.only(
        top: isFirstButton ? 0 : 6,
        bottom: isLastButton ? 0 : 0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _handleButtonTap(context, button),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: buttonBorderColor ?? Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              color: buttonBackgroundColor ?? Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getButtonIcon(button.action.type),
                  size: 18,
                  color: buttonTextColor ?? Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    button.title,
                    style: TextStyle(
                      color: buttonTextColor ?? Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getButtonIcon(String actionType) {
    switch (actionType) {
      case 'reply':
        return Icons.reply;
      case 'link':
        return Icons.open_in_new;
      default:
        return Icons.touch_app;
    }
  }

  void _handleButtonTap(BuildContext context, ChatButton button) async {
    switch (button.action.type) {
      case 'reply':
        // Send the button value as a reply message
        if (onButtonPressed != null) {
          onButtonPressed!(button.action.value);
        }
        break;
      case 'link':
        // Open the URL
        await _openUrl(button.action.value);
        break;
      default:
        // Default action - treat as reply
        if (onButtonPressed != null) {
          onButtonPressed!(button.action.value);
        }
        break;
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}