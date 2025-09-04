import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';

class ImagePickerWidget extends StatelessWidget {
  final Function(XFile image) onImageSelected;
  final Color? buttonColor;
  final bool allowMultiple;
  final String? hint;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.buttonColor,
    this.allowMultiple = false,
    this.hint,
  });

  void _showImageSourceDialog(BuildContext context) {
    final ImageService imageService = ImageService();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hint ?? 'Select Image Source',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option (only for mobile)
                  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                    _buildSourceOption(
                      context,
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () async {
                        Navigator.pop(context);
                        final image = await imageService.pickImageFromCamera();
                        if (image != null) {
                          onImageSelected(image);
                        }
                      },
                    ),
                  ],
                  // Gallery option
                  _buildSourceOption(
                    context,
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      if (allowMultiple) {
                        final images = await imageService.pickMultipleImages();
                        for (final image in images) {
                          onImageSelected(image);
                        }
                      } else {
                        final image = await imageService.pickImageFromGallery();
                        if (image != null) {
                          onImageSelected(image);
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: buttonColor?.withValues(alpha: 0.1) ?? Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: buttonColor ?? Colors.blue,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: buttonColor ?? Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: buttonColor ?? Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.image),
      color: buttonColor ?? Colors.blue,
      onPressed: () => _showImageSourceDialog(context),
    );
  }
}

// Widget para exibir imagem selecionada
class ImageMessageWidget extends StatelessWidget {
  final String imagePath;
  final String? caption;
  final bool isUrl;
  final VoidCallback? onTap;

  const ImageMessageWidget({
    super.key,
    required this.imagePath,
    this.caption,
    this.isUrl = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showFullScreenImage(context),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: 300,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Flexible(
                child: _buildImage(),
              ),
              // Caption
              if (caption != null && caption!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    caption!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    Widget imageWidget;
    
    if (isUrl) {
      imageWidget = Image.network(
        imagePath,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text('Failed to load image'),
              ],
            ),
          );
        },
      );
    } else {
      if (kIsWeb) {
        imageWidget = Image.network(
          imagePath,
          fit: BoxFit.contain,
        );
      } else {
        imageWidget = Image.file(
          File(imagePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 150,
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Failed to load image'),
                ],
              ),
            );
          },
        );
      }
    }
    
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 250,
      ),
      child: imageWidget,
    );
  }

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              child: InteractiveViewer(
                child: _buildImage(),
              ),
            ),
          ),
        );
      },
    );
  }
}