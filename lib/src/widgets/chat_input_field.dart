import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'audio_recorder_widget.dart';
import 'image_picker_widget.dart';
import 'microphone_selector.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color backgroundColor;
  final Color sendButtonColor;
  final VoidCallback onSend;
  final bool isLoading;
  final bool enableAudio;
  final bool enableImage;
  final bool waitForResponse;
  final String language;
  final Color? audioButtonColor;
  final Color? imageButtonColor;
  final Function(String audioPath)? onAudioRecorded;
  final Function(XFile image)? onImageSelected;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.backgroundColor,
    required this.sendButtonColor,
    required this.onSend,
    required this.isLoading,
    this.enableAudio = false,
    this.enableImage = false,
    this.waitForResponse = true,
    this.language = 'pt-BR',
    this.audioButtonColor,
    this.imageButtonColor,
    this.onAudioRecorded,
    this.onImageSelected,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  void _showAudioRecorder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Microphone selector
            MicrophoneSelector(
              primaryColor: widget.audioButtonColor,
              language: widget.language,
            ),
            
            const SizedBox(height: 16),
            
            // Audio recorder
            AudioRecorderWidget(
              buttonColor: widget.audioButtonColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
              language: widget.language,
              onAudioRecorded: (audioPath) {
                Navigator.pop(context);
                if (widget.onAudioRecorded != null) {
                  widget.onAudioRecorded!(audioPath);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          if (widget.enableImage) ...[
            ImagePickerWidget(
              buttonColor: widget.imageButtonColor,
              onImageSelected: (image) {
                if (widget.onImageSelected != null) {
                  widget.onImageSelected!(image);
                }
              },
            ),
          ],
          if (widget.enableAudio) ...[
            IconButton(
              icon: Icon(
                Icons.mic,
                color: widget.audioButtonColor ?? Colors.red,
              ),
              onPressed: (widget.waitForResponse && widget.isLoading) ? null : _showAudioRecorder,
            ),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              enabled: !(widget.waitForResponse && widget.isLoading),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => widget.onSend(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: widget.sendButtonColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.sendButtonColor,
            ),
            child: IconButton(
              icon: (widget.waitForResponse && widget.isLoading)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
              onPressed: (widget.waitForResponse && widget.isLoading) ? null : widget.onSend,
            ),
          ),
        ],
      ),
    );
  }
}