import 'package:flutter/material.dart';

class AnimatedLoadingDots extends StatefulWidget {
  final Color? color;
  final double size;
  final int dotCount;
  final Duration animationDuration;

  const AnimatedLoadingDots({
    super.key,
    this.color,
    this.size = 8.0,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<AnimatedLoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = [];
    _animations = [];

    for (int i = 0; i < widget.dotCount; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            i / widget.dotCount,
            (i + 1) / widget.dotCount,
            curve: Curves.easeInOut,
          ),
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);

      // Start animation with delay for each dot
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          controller.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Colors.grey;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.dotCount,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
              child: Transform.translate(
                offset: Offset(0, -_animations[index].value * widget.size * 0.5),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(
                      alpha: 0.4 + (_animations[index].value * 0.6),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  final Color bubbleColor;
  final Color textColor;
  final String chatName;
  final String profileImageUrl;
  final Widget? customAvatar;

  const TypingIndicator({
    super.key,
    required this.bubbleColor,
    required this.textColor,
    required this.chatName,
    required this.profileImageUrl,
    this.customAvatar,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'AI';
    
    List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].length >= 2 
          ? words[0].substring(0, 2).toUpperCase() 
          : words[0].toUpperCase();
    }
    
    String initials = '';
    for (int i = 0; i < words.length && initials.length < 2; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }
    return initials.isEmpty ? 'AI' : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customAvatar ?? CircleAvatar(
            radius: 16,
            backgroundColor: bubbleColor,
            child: Text(
              _getInitials(chatName),
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: AnimatedLoadingDots(
                color: textColor,
                size: 10.0,
                dotCount: 3,
                animationDuration: const Duration(milliseconds: 1200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}